/*
 * Copyright 2015-present StylingKit Development Team
 * Copyright 2012-present Pixate, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  UIView+PXStyling.m
//  PXButtonDemo
//
//  Modified by Anton Matosov
//  Created by Kevin Lindsey on 8/22/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import "PixateFreestyle.h"
#import <objc/runtime.h>
#import "UIView+PXStyling.h"
#import "NSObject+PXSubclass.h"
#import "PXLoggingUtils.h"
#import "PXStyleUtils.h"
#import "PixateFreestyle-Private.h"
#import "PixateFreestyle.h"
#import "PXStylesheet-Private.h"
#import "NSDictionary+PXCSSEncoding.h"
#import "PXRuntimeUtils.h"
#import "PXUtils.h"
#import "NSMutableArray+QueueAdditions.h"
#import "NSObject+PXClass.h"
#import "NSObject+PXStyling.h"
#import "PXStylingMacros.h"
#import "UIView+PXStyling-Private.h"
#import "NSObject+PXSwizzle.h"
#import "STK_UIAlertControllerView.h"

static const char STYLE_ELEMENT_NAME_KEY;
static const char STYLE_CLASS_KEY;
static const char STYLE_CLASSES_KEY;
static const char STYLE_ID_KEY;
static const char STYLE_CHANGEABLE_KEY;
static const char STYLE_CSS_KEY;
static const char STYLE_MODE_KEY;
static const char KVC_DICTIONARY;
static const char KVC_SET;

static Class SubclassForViewWithClass(UIView *view, Class viewClass);

void PXForceLoadUIViewPXStyling() {}

@implementation UIView (PXStyling)

@dynamic bounds;
@dynamic frame;

STK_DEFINE_CLASS_LOG_LEVEL;


static NSMutableArray *DYNAMIC_SUBCLASSES;

#pragma mark - Static Methods

+ (void)setElementName:(NSString *)elementName forClass:(Class)class
{
    if (elementName && class)
    {
        objc_setAssociatedObject(class, &STYLE_ELEMENT_NAME_KEY, elementName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

+ (NSString *)elementNameForClass:(Class)class
{
    return objc_getAssociatedObject(class, &STYLE_ELEMENT_NAME_KEY);
}

+ (NSString *)elementNameForClassName:(NSString *)className
{
    return [self elementNameForClass:NSClassFromString(className)];
}

+ (void)addStylingSubclass:(NSString *)className
{
    if(DYNAMIC_SUBCLASSES == nil)
    {
        DYNAMIC_SUBCLASSES = [[NSMutableArray alloc] init];
    }

    if (className)
    {
        [DYNAMIC_SUBCLASSES addObject:NSClassFromString(className)];
    }
}

+ (BOOL)hasStylingSubclass:(NSString *)className
{
    return ([DYNAMIC_SUBCLASSES indexOfObject:NSClassFromString(className)] != NSNotFound);
}

- (BOOL)isSubclassable
{
    return ([self.pxStyleElementName isEqualToString:@"<undefined>"] == NO);
}

+ (void)removeStylingSubclass:(NSString *)className
{
    [DYNAMIC_SUBCLASSES removeObject:NSClassFromString(className)];
}

+ (void)registerDynamicSubclass:(Class)subclass forClass:(Class)superClass withElementName:(NSString *)elementName
{
    @autoreleasepool
    {
        if(subclass && superClass)
        {
            NSString *className = @(class_getName(subclass));

            [self setElementName:elementName forClass:superClass];
            [self addStylingSubclass:className];
        }
    }
}

+ (void)registerDynamicSubclass:(Class)subclass withElementName:(NSString *)elementName
{
    @autoreleasepool
    {
        NSString *className = @(class_getName(subclass));

        [self setElementName:elementName forClass:class_getSuperclass(subclass)];
        [self addStylingSubclass:className];
    }
}

#pragma mark - Dynamic subclassing initializer and property

+ (void)initialize
{
    if (self != UIView.class)
        return;
    
    @autoreleasepool
    {
#ifdef PX_LOGGING
        // turn on logging
        [PXLoggingUtils enableLogging];

        // set logging level for all classes
        //[PXLoggingUtils setGlobalLoggingLevel:LOG_LEVEL_VERBOSE];
#endif

        [self swizzleMethod:@selector(initWithFrame:) withMethod:@selector(stk_initWithFrame:)];
        [self swizzleMethod:@selector(initWithCoder:) withMethod:@selector(stk_initWithCoder:)];
    }
}

- (instancetype)stk_initWithFrame:(CGRect)frame
{
    [self stk_initWithFrame:frame];
    [self stk_subclassIfNeeded];
    return self;
}

- (instancetype)stk_initWithCoder:(NSCoder *)aDecoder
{
    [self stk_initWithCoder:aDecoder];
    [self stk_subclassIfNeeded];
    return self;
}

- (void)stk_subclassIfNeeded
{
    if ([self stk_isSublcassingException])
    {
        return;
    }

    // Grabbing Pixate's subclass of this instance
    Class viewDynamicSubclass = SubclassForViewWithClass(self, nil);

    if(viewDynamicSubclass)
    {
        //NSLog(@"%@ (%p): %@ -> %@", [self class], self, [[self class] superclass], c);

        // We are subclassing 'self' with the Pixate class 'c' we found above
        [viewDynamicSubclass subclassInstance:self];

        // Register for notification center events
        static char Notification;
        if (!objc_getAssociatedObject(self, &Notification))
        {
            objc_setAssociatedObject(self, &Notification, @(YES), OBJC_ASSOCIATION_COPY_NONATOMIC);

            if ([self respondsToSelector:@selector(registerNotifications)])
            {
                [self performSelector:@selector(registerNotifications)];
            }
        }
    }
}
- (BOOL)stk_isSublcassingException
{
    static NSMutableSet<Class> *exceptions;
    static NSMutableSet<NSString *> *exceptionClassNames;
    static NSMutableSet<NSString *> *matchedClasses;

    static dispatch_once_t once;
    dispatch_once(&once, ^{
        exceptions = [NSMutableSet new];
        exceptionClassNames = [NSMutableSet new];
        matchedClasses = [NSMutableSet new];

        NSString *prefix = @"CAM";
        if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0)
        {
            prefix = @"CMK";
        }
        [exceptionClassNames addObject:[NSString stringWithFormat:@"%@%@%@", prefix, @"Flip", @"Button" ]];
        [exceptionClassNames addObject:[NSString stringWithFormat:@"%@%@%@", prefix, @"Shutter", @"Button" ]];
    });

    for (NSString *name in exceptionClassNames)
    {
        Class except = NSClassFromString(name);
        if (except)
        {
            [exceptions addObject:except];
            [matchedClasses addObject:name];
        }
    }
    [exceptionClassNames minusSet:matchedClasses];
    [matchedClasses removeAllObjects];

    return [exceptions containsObject:self.class];
}

+ (BOOL)subclassIfNeeded:(Class)superClass object:(NSObject *)object
{
    if(![object respondsToSelector:@selector(pxClass)])
    {
        [superClass subclassInstance:object];
        return YES;
    }

    return NO;
}

#pragma mark - Styling methods for appearance api

- (PXStylingMode)styleMode
{
    NSNumber *modeVal = objc_getAssociatedObject(self, &STYLE_MODE_KEY);

    if(modeVal)
    {
        return (PXStylingMode)modeVal.intValue;
    }

    return PXStylingUndefined;
}

- (void)setStyleMode:(PXStylingMode) mode
{
    objc_setAssociatedObject(self, &STYLE_MODE_KEY, @(mode), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Styling properties on UIView

- (NSString *)pxStyleElementName
{
    Class class = self.class;
    NSString *name = [UIView elementNameForClass:class];

    if (!name)
    {
        while (class && !name)
        {
            class = class_getSuperclass(class);

            if (class)
            {
                name = [UIView elementNameForClass:class];
            }
        }

        if (name)
        {
            [UIView setElementName:name forClass:self.class];
        }
    }

    return (name) ? name : @"<undefined>";
}

- (NSString *)styleClass
{
    return objc_getAssociatedObject(self, &STYLE_CLASS_KEY);
}

- (NSSet *)styleClasses
{
    return objc_getAssociatedObject(self, &STYLE_CLASSES_KEY);
}

- (NSString *)styleId
{
    NSString *id = objc_getAssociatedObject(self, &STYLE_ID_KEY);
    return id;
}

- (BOOL)styleChangeable
{
    return [objc_getAssociatedObject(self, &STYLE_CHANGEABLE_KEY) boolValue];
}

- (id)pxStyleParent
{
    return self.superview;
}

- (NSArray *)pxStyleChildren
{
    return self.subviews;
}

- (NSString *)styleCSS
{
    NSMutableDictionary *properties = objc_getAssociatedObject(self, &KVC_DICTIONARY);

    if (properties != nil)
    {
        NSMutableOrderedSet *set = objc_getAssociatedObject(self, &KVC_SET);

        return [properties toCSSWithKeys:set.array];
    }
    else
    {
        return objc_getAssociatedObject(self, &STYLE_CSS_KEY);
    }
}

- (NSString *)styleKey
{
    return [PXStyleUtils styleKeyFromStyleable:self];
}

- (void)setStyleClass:(NSString *)aClass
{
    // make sure we have a string - needed to filter bad input from IB
    aClass = [aClass.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

#if 0
    if (aClass.length)
    {
        aClass = [NSString stringWithFormat:@"%@ debug", aClass];
    }
#endif

    objc_setAssociatedObject(self, &STYLE_CLASS_KEY, aClass, OBJC_ASSOCIATION_COPY_NONATOMIC);

    NSArray *classes = [aClass componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableSet *styleClasses = [NSMutableSet setWithArray:classes];
    objc_setAssociatedObject(self, &STYLE_CLASSES_KEY, styleClasses, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

//
//	// reduce white spaces and duplicates
//	NSMutableSet *mutSet = [NSMutableSet setWithArray:[aClass componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
//	[mutSet removeObject:@""];
//
//    //Precalculate classes array for performance gain
//    NSArray *classes = mutSet.allObjects;
//
//	aClass = [classes componentsJoinedByString:@" "];
//
//	NSString *previousClass = objc_getAssociatedObject(self, &STYLE_CLASS_KEY);
//	if((!aClass && !previousClass) || [aClass isEqualToString:previousClass]){
//		// no change
//		return;
//	}
//
//	objc_setAssociatedObject(self, &STYLE_CLASS_KEY, aClass, OBJC_ASSOCIATION_COPY_NONATOMIC);
//
//    objc_setAssociatedObject(self, &STYLE_CLASSES_KEY, mutSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//
//	if (aClass.length)
//    {
////        self.styleMode = PXStylingNormal;
//	}
//
////    [[PXStyleController sharedInstance] setViewNeedsStyle:self];
}

- (void)setStyleId:(NSString *)anId
{
    // make sure we have a string - needed to filter bad input from IB
    anId = anId.description;

    // trim leading and trailing whitespace
    anId = [anId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    objc_setAssociatedObject(self, &STYLE_ID_KEY, anId, OBJC_ASSOCIATION_COPY_NONATOMIC);

    if (anId.length)
    {
        self.styleMode = PXStylingNormal;
	}

//    [[PXStyleController sharedInstance] setViewNeedsStyle:self];
}

- (void)setStyleChangeable:(BOOL)changeable
{
    objc_setAssociatedObject(self, &STYLE_CHANGEABLE_KEY, @(changeable), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setStyleCSS:(NSString *)css
{
    // make sure we have a string - needed to filter bad input from IB
    css = css.description;

    objc_setAssociatedObject(self, &STYLE_CSS_KEY, css, OBJC_ASSOCIATION_COPY_NONATOMIC);

    if (css.length)
    {
        self.styleMode = PXStylingNormal;
	}

//    [[PXStyleController sharedInstance] setViewNeedsStyle:self];
}

- (NSString *)attributeValueForName:(NSString *)name withNamespace:(NSString *)namespace
{
    NSString *stringValue = nil;

    @try
    {
        id value = [self valueForKey:name];

        if ([value isKindOfClass:[NSObject class]])
        {
            stringValue = ((NSObject *)value).description;
        }
    }
    @catch (NSException *e) {
        // do nothing
    }

    return stringValue;
}

#pragma mark - Static Styling Method

+ (void)updateStyles:(id<PXStyleable>)styleable recursively:(bool)recurse
{
    if (styleable.styleMode != PXStylingNone)
    {
        // If not recursive, style virtual children only (not subviews)
        if(!recurse)
        {
            [self prv_updateStylesForVirtualChildrenOfStylable:styleable];
        }
        
        // Style the styleable and optionally ALL the children (including virtual children)
        [PXStyleUtils updateStylesForStyleable:styleable
                                andDescendants:recurse];
    }
}

+ (void)prv_updateStylesForVirtualChildrenOfStylable:(id <PXStyleable>)styleable
{
    for (id<PXStyleable> child in styleable.pxStyleChildren)
    {
        if (child.styleMode == PXStylingNormal
            && [child conformsToProtocol:@protocol(PXVirtualControl)])
        {
            [PXStyleUtils enumerateStyleableDescendants:child
                                             usingBlock:^(id <PXStyleable> childStyleable, BOOL *stop, BOOL *stopDescending)
                                             {
                                                 if (childStyleable.styleMode == PXStylingNormal
                                                     && [childStyleable conformsToProtocol:@protocol(PXVirtualControl)])
                                                 {
                                                     [PXStyleUtils updateStyleForStyleable:childStyleable];
                                                 }
                                             }];

            [PXStyleUtils updateStyleForStyleable:child];
        }
    }
}

#pragma mark - Methods

- (void)updateStyles
{
    [UIView updateStyles:self recursively:YES];
}

- (void)updateStylesNonRecursively
{
    [UIView updateStyles:self recursively:NO];
}

- (void)updateStylesAsync
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateStyles];
    });
}

-(void)updateStylesNonRecursivelyAsync
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateStylesNonRecursively];
    });
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if (value == nil || [value isKindOfClass:[NSString class]])
    {
        NSMutableDictionary *properties = objc_getAssociatedObject(self, &KVC_DICTIONARY);
        NSMutableOrderedSet *set = objc_getAssociatedObject(self, &KVC_SET);

        if ([key hasPrefix:@"+"])
        {
            key = [key substringFromIndex:1];
        }

        if (properties == nil)
        {
            properties = [[NSMutableDictionary alloc] init];
            objc_setAssociatedObject(self, &KVC_DICTIONARY, properties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            set = [[NSMutableOrderedSet alloc] init];
            objc_setAssociatedObject(self, &KVC_SET, set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }

        if (key == nil)
        {
            [set removeObject:key];
        }
        else
        {
            [set addObject:key];
        }

        [properties setValue:value forKey:key];
    }
}

- (id)valueForUndefinedKey:(NSString *)key
{
    NSMutableDictionary *properties = objc_getAssociatedObject(self, &KVC_DICTIONARY);

    if ([key hasPrefix:@"+"])
    {
        key = [key substringFromIndex:1];
    }

    id value = properties[key];

    return (value != nil) ? value : [super valueForUndefinedKey:key];
}

- (void)addStyleClass:(NSString *)styleClass
{
    if (self.styleClass){
        self.styleClass = [NSString stringWithFormat:@"%@ %@", self.styleClass, styleClass.description];
    } else {
        self.styleClass = styleClass.description;
    }
}

- (void)removeStyleClass:(NSString *)styleClass
{
    styleClass = [styleClass.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSArray *toRemove = [styleClass componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSMutableSet *newClasses = self.styleClasses.mutableCopy;
    [newClasses minusSet:[NSSet setWithArray:toRemove]];

	self.styleClass = [newClasses.allObjects componentsJoinedByString:@" "];
}

- (void)styleClassed:(NSString *)styleClass enabled:(bool)enabled
{
	if(enabled){
		[self addStyleClass:styleClass];
	}else{
		[self removeStyleClass:styleClass];
	}
}

- (void)stkUpdateStylesFromLayoutSubviewsRecursively:(BOOL)recursively
{
    [UIView updateStyles:self recursively:recursively];
}

@end

#pragma mark - Static Functions


static Class SubclassForViewWithClass(UIView *view, Class viewClass)
{
	if (viewClass == nil)
    {
		viewClass = object_getClass(view);
	}

	if ([UIResponder class] == viewClass)
    {
		return nil;
	}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
	if ([view respondsToSelector:@selector(pxClass)])
    {
        return nil;
	}

    if (class_getInstanceMethod(viewClass, @selector(pxClass)) != NULL)
    {
        return nil;
    }
#pragma clang diagnostic pop

	for (Class c in DYNAMIC_SUBCLASSES)
    {
		if (c == viewClass)
        {
			return nil;
		}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        
		if ([c respondsToSelector:@selector(targetSuperclass)])
        {
			if ([c performSelector:@selector(targetSuperclass)] == viewClass)
            {
				return c;
			}
		}
#pragma clang diagnostic pop
        
        else if (class_getSuperclass(c) == viewClass)
        {
			return c;
		}
	}

	return SubclassForViewWithClass(view, class_getSuperclass(viewClass));
}






