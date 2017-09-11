/*
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
//  PXUICollectionView.m
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Paul Colton on 10/11/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import "PXUICollectionView.h"
#import <QuartzCore/QuartzCore.h>

#import "UIView+PXStyling.h"
#import "UIView+PXStyling-Private.h"
#import "PXStylingMacros.h"
#import "PXOpacityStyler.h"
#import "PXLayoutStyler.h"
#import "PXTransformStyler.h"
#import "PXVirtualStyleableControl.h"
#import "PXStyleUtils.h"

#import "PXShapeStyler.h"
#import "PXFillStyler.h"
#import "PXBorderStyler.h"
#import "PXBoxShadowStyler.h"
#import "PXAnimationStyler.h"
#import "PXGenericStyler.h"

#import "PXProxy.h"
#import "NSObject+PXSubclass.h"
#import "PXUICollectionViewDelegate.h"
#import "NSObject+PXSwizzle.h"

static const char PX_DELEGATE; // the new delegate (and datasource)
static const char PX_DELEGATE_PROXY; // the proxy for the old delegate
static const char PX_DATASOURCE_PROXY; // the proxy for the old datasource

@implementation UICollectionView (PXFreestyle)

+ (void)initialize
{
    if (self != UICollectionView.class)
        return;
    
    [self swizzleMethod:@selector(setDelegate:) withMethod:@selector(px_setDelegate:)];
    [self swizzleMethod:@selector(setDataSource:) withMethod:@selector(px_setDataSource:)];
}

-(void)px_setDelegate:(id<UICollectionViewDelegate>)delegate
{
    id proxy = [self stk_makeProxyFor:delegate withAssocObjectAddress:&PX_DELEGATE_PROXY];
    [self px_setDelegate:proxy];
}

-(void)px_setDataSource:(id<UICollectionViewDataSource>)dataSource
{
    id proxy = [self stk_makeProxyFor:dataSource withAssocObjectAddress:&PX_DATASOURCE_PROXY];
    [self px_setDataSource:proxy];
}

#pragma mark - Delegate and DataSource proxy methods

- (id <UICollectionViewDataSource>)stk_makeProxyFor:(id)dataSource withAssocObjectAddress:(const void *)variableAddress
{
    id proxy = dataSource ? [[PXProxy alloc] initWithBaseOject:dataSource overridingObject:[self pxDelegate]] : nil;
    if (proxy)
    {
        objc_setAssociatedObject(self, variableAddress, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return proxy;
}

- (PXUICollectionViewDelegate *)pxDelegate
{
    PXUICollectionViewDelegate *delegate = objc_getAssociatedObject(self, &PX_DELEGATE);

    if(delegate == nil)
    {
        delegate = [[PXUICollectionViewDelegate alloc] init];
        delegate.collectionView = self;
        objc_setAssociatedObject(self, &PX_DELEGATE, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return delegate;
}

@end

//
// PXUICollectionView
//

@implementation PXUICollectionView

#pragma mark - Static load

+ (void)initialize
{
    if (self != PXUICollectionView.class)
        return;
    
    [UIView registerDynamicSubclass:self withElementName:@"collection-view"];
}

#pragma mark - Stylers

- (NSArray *)viewStylers
{
    static __strong NSArray *stylers = nil;
	static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{

        stylers = @[
            PXTransformStyler.sharedInstance,
            PXLayoutStyler.sharedInstance,
            PXOpacityStyler.sharedInstance,

            PXShapeStyler.sharedInstance,
            PXFillStyler.sharedInstance,
            PXBorderStyler.sharedInstance,
            PXBoxShadowStyler.sharedInstance,

            PXAnimationStyler.sharedInstance,
            
            [[PXGenericStyler alloc] initWithHandlers: @{
                @"cell-size" :  ^(PXDeclaration *declaration, PXStylerContext *context) {
                    CGSize size = declaration.sizeValue;
                    PXUICollectionViewDelegate *delegate = [self pxDelegate];
                    delegate.itemSize.size = size;
                },
             
                @"cell-width" :  ^(PXDeclaration *declaration, PXStylerContext *context) {
                    CGFloat width = declaration.floatValue;
                    PXUICollectionViewDelegate *delegate = [self pxDelegate];
                    delegate.itemSize.size = CGSizeMake(width, delegate.itemSize.size.height);
                },
                
                @"cell-height" :  ^(PXDeclaration *declaration, PXStylerContext *context) {
                    CGFloat height = declaration.floatValue;
                    PXUICollectionViewDelegate *delegate = [self pxDelegate];
                    delegate.itemSize.size = CGSizeMake(delegate.itemSize.size.width, height);
                },
                
                @"selection-mode" : ^(PXDeclaration *declaration, PXStylerContext *context) {
                    PXUICollectionView *view = (PXUICollectionView *)context.styleable;
                    NSString *mode = (declaration.stringValue).lowercaseString;
                    
                    if([mode isEqualToString:@"single"])
                    {
                        view.allowsMultipleSelection = NO;
                    }
                    else if([mode isEqualToString:@"multiple"])
                    {
                        view.allowsMultipleSelection = YES;
                    }
                },
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

#pragma mark - Update Styles

- (void)updateStyleWithRuleSet:(PXRuleSet *)ruleSet context:(PXStylerContext *)context
{
    if (context.usesColorOnly)
    {
        [self px_setBackgroundView: nil];
        [self px_setBackgroundColor: context.color];
    }
    else if (context.usesImage)
    {
        [self px_setBackgroundColor: [UIColor clearColor]];
        //[self px_setBackgroundColor: [UIColor colorWithPatternImage:context.backgroundImage]];
        [self px_setBackgroundView: [[UIImageView alloc] initWithImage:context.backgroundImage]];
    }
}


#pragma mark - Overrides

// None

#pragma mark - Wrappers

// Px Wrapped Only
PX_PXWRAP_PROP(CALayer, layer);

// Ti Wrapped
PX_WRAP_PROP(UIView, backgroundView);

PX_WRAP_1(setBackgroundColor, color);
PX_WRAP_1(setBackgroundView, view);

PX_LAYOUT_SUBVIEWS_OVERRIDE_RECURSIVE

@end
