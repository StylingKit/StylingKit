//
//  Test.m
//  StylingKit
//
//  Created by politom on 07/06/2018.
//  Copyright © 2018 CSE. All rights reserved.
//

#import "STStyleable.H"
#import "NSObject+PXClass.h"
#import "UIView+PXStyling.h"
#import "UIView+PXStyling-Private.h"
#import "PXStylingMacros.h"
#import "PXViewUtils.h"
#import "PXStyleUtils.h"
#import "NSMutableDictionary+PXObject.h"
#import "NSDictionary+PXObject.h"
#import "PXUIView.h"

#import "PXOpacityStyler.h"
#import "PXFontStyler.h"
#import "PXPaintStyler.h"
#import "PXDeclaration.h"
#import "PXRuleSet.h"
#import "PXLayoutStyler.h"
#import "PXTransformStyler.h"
#import "PXTextContentStyler.h"
#import "PXGenericStyler.h"
#import "PXShapeStyler.h"
#import "PXFillStyler.h"
#import "PXBorderStyler.h"
#import "PXBoxShadowStyler.h"
#import "PXAnimationStyler.h"
#import "PXTextShadowStyler.h"
#import "PXAttributedTextStyler.h"
#import "PXVirtualStyleableControl.h"
#import "PXColorStyler.h"

@implementation STStyleable

@synthesize bounds;

@synthesize pxStyleChildren;
@synthesize pxStyleParent;
@synthesize styleChangeable;
@synthesize styleClass;
@synthesize styleClasses;

@synthesize font;
@synthesize color;

- (void)setStyleClass:(NSString *)aClass
{
    // make sure we have a string - needed to filter bad input from IB
    aClass = [aClass.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *classes = [aClass componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    styleClasses = [NSMutableSet setWithArray:classes];
}

@synthesize styleId;

- (NSString *)pxStyleElementName
{
    return @"styleable";
}
- (NSString *)styleKey
{
    return [PXStyleUtils styleKeyFromStyleable:self];
}

@synthesize frame;

- (PXStylingMode)styleMode
{
    return PXStylingNormal;
}

- (NSString *)defaultPseudoClass
{
    return @"normal";
}

- (NSArray *)viewStylers
{
    static __strong NSArray *stylers = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        stylers = @[
                    PXOpacityStyler.sharedInstance,
                    PXFillStyler.sharedInstance,
                    PXBorderStyler.sharedInstance,
                    PXBoxShadowStyler.sharedInstance,
                    [[PXColorStyler alloc] initWithCompletionBlock:^(STStyleable *view, PXColorStyler *styler, PXStylerContext *context) {
                        UIColor *color = (UIColor *) [context propertyValueForName:@"color"];

                        if(color)
                        {
                            [view setColor:color];
                        }
                    }],
                    [[PXFontStyler alloc] initWithCompletionBlock:^(STStyleable *view, PXFontStyler *styler, PXStylerContext *context) {
                        [view setFont:context.font];
                    }]
        ];
    });
    
    return stylers;
}

- (NSDictionary *)viewStylersByProperty
{
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        map = [PXStyleUtils viewStylerPropertyMapForStyleable:self];
    });
    
    return map;
}

- (void)updateStyleWithRuleSet:(PXRuleSet*)ruleSet context:(PXStylerContext*)context {
    
    self.backgroundColor = context.fill;
    
}

@end
