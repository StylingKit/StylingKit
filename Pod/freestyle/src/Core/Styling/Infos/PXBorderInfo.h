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
//  PXBorderInfo.h
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 3/25/13.
//  Copyright (c) 2013 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXPaint.h"

typedef NS_ENUM(unsigned int, PXBorderStyle) {
    PXBorderStyleNone,
    PXBorderStyleHidden,
    PXBorderStyleDotted,
    PXBorderStyleDashed,
    PXBorderStyleSolid,
    PXBorderStyleDouble,
    PXBorderStyleGroove,
    PXBorderStyleRidge,
    PXBorderStyleInset,
    PXBorderStyleOutset
};

@interface PXBorderInfo : NSObject

@property (nonatomic) id<PXPaint> paint;
@property (nonatomic) PXBorderStyle style;
@property (nonatomic) CGFloat width;

- (instancetype)initWithPaint:(id<PXPaint>)paint width:(CGFloat)width;
- (instancetype)initWithPaint:(id<PXPaint>)paint width:(CGFloat)width style:(PXBorderStyle)style NS_DESIGNATED_INITIALIZER;

@property (NS_NONATOMIC_IOSONLY, getter=isOpaque, readonly) BOOL opaque;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL hasContent;

@end
