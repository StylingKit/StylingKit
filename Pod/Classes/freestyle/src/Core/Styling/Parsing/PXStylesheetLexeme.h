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
//  PXLexeme.h
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 6/23/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXLexeme.h"

typedef NS_ENUM(unsigned int, PXLexemeFlagType) {
    PXLexemeFlagFollowsWhitespace = 1
};

@interface PXStylesheetLexeme : NSObject <PXLexeme>

+ (instancetype)lexemeWithType:(int)type;
+ (instancetype)lexemeWithType:(int)type withRange:(NSRange)range;
+ (instancetype)lexemeWithType:(int)type withValue:(id)value;
+ (instancetype)lexemeWithType:(int)type withRange:(NSRange)range withValue:(id)value;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithType:(int)type withRange:(NSRange)range withValue:(id)value NS_DESIGNATED_INITIALIZER;

@end
