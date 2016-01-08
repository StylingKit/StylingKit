/*
 * Copyright 2015-present StylingKit Development Team. All rights reserved..
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
// Created by Anton Matosov on 1/5/16.
//


#import "PXAnimationStyler.h"
#import "UIView+PXStyling-Private.h"
#import "PXOpacityStyler.h"
#import "PXShapeStyler.h"
#import "PXFillStyler.h"
#import "PXBorderStyler.h"
#import "PXBoxShadowStyler.h"
#import "PXStylingMacros.h"
#import "STK_UIAlertControllerView.h"

@implementation STK_UIAlertControllerView

+ (void)initialize
{
  if (self != STK_UIAlertControllerView.class)
    return;

  [UIView registerDynamicSubclass:self
                         forClass:[self targetSuperclass]
                  withElementName:@"alert-view"];
}

+ (Class)targetSuperclass
{
  static Class targetSuperclass = nil;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
      targetSuperclass = NSClassFromString([[self description] substringFromIndex:3]);
  });

  return targetSuperclass;
}

- (NSArray*)viewStylers {
  static __strong NSArray* stylers = nil;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
      stylers = @[
        PXOpacityStyler.sharedInstance,
        PXShapeStyler.sharedInstance,
        PXFillStyler.sharedInstance,
        PXBorderStyler.sharedInstance,
        PXBoxShadowStyler.sharedInstance,
        PXAnimationStyler.sharedInstance,
      ];
  });

  return stylers;
}

- (NSDictionary*)viewStylersByProperty {
  static NSDictionary* map = nil;
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
      map = [PXStyleUtils viewStylerPropertyMapForStyleable:self];
  });

  return map;
}

- (void)updateStyleWithRuleSet:(PXRuleSet*)ruleSet context:(PXStylerContext*)context {
  self.px_layer.contents = (__bridge id)(context.backgroundImage.CGImage);
}

// Px Wrapped Only
PX_PXWRAP_PROP(CALayer, layer);

// Styling overrides
PX_LAYOUT_SUBVIEWS_OVERRIDE

@end
