/****************************************************************************
 *
 * Copyright 2015-present StylingKit Development Team. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 ****************************************************************************/

//
// Created by Anton Matosov
//

#import <Foundation/Foundation.h>

@class STKTheme;
@class STKCloud;

@interface StylingKit : NSObject

@property (readonly, nonatomic) STKTheme *currentTheme;
@property(readonly, nonatomic) STKCloud *cloud;

/// Shared and only allowed instance of the StylingKit to be used in the app
+ (instancetype)sharedKit;

- (void)startStyling;

- (STKTheme*)registerThemeNamed:(NSString*)themeName
                       inBundle:(NSBundle*)bundle;

- (instancetype)init NS_UNAVAILABLE;

@end


@interface UIView (StylingKit)

@property (nonatomic, copy) IBInspectable NSString *styleId;
@property (nonatomic, copy) IBInspectable NSString *styleClass;
@property (nonatomic, copy) IBInspectable NSString *styleCSS;

@end
