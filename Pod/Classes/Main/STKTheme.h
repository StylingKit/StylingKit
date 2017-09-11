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
// Created by Anton Matosov on 1/18/16.
//

#import <Foundation/Foundation.h>

@interface STKTheme : NSObject

@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* stylesheetFileName;
@property(strong, nonatomic) NSBundle* bundle;
@property(assign, nonatomic) BOOL optional;

@property (readonly, nonatomic) NSString *loadedFromPath;
@property(assign, nonatomic) NSUInteger origin; // TODO: get rid of this once full themes support is implemented

+ (instancetype)themeWithName:(NSString*)name
                       bundle:(NSBundle*)bundle;
+ (instancetype)themeWithName:(NSString*)name
           stylesheetFileName:(NSString*)stylesheetFileName
                       bundle:(NSBundle*)bundle;

- (BOOL)activate;
- (NSString*)description;

@end
