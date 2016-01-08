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
//  PXDimension.m
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 7/7/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import "PXDimension.h"
#import "PXMath.h"

@implementation PXDimension

@synthesize number;
@synthesize dimension;
@synthesize type;

static NSDictionary *dimensionMap;

+ (void)initialize
{
    dimensionMap = @{@"em": @(kDimensionTypeEms),
                    @"ex": @(kDimensionTypeExs),
                    @"px": @(kDimensionTypePixels),
                    @"dpx": @(kDimensionTypeDevicePixels),
                    @"cm": @(kDimensionTypeCentimeters),
                    @"mm": @(kDimensionTypeMillimeters),
                    @"in": @(kDimensionTypeInches),
                    @"pt": @(kDimensionTypePoints),
                    @"pc": @(kDimensionTypePicas),
                    @"deg": @(kDimensionTypeDegrees),
                    @"rad": @(kDimensionTypeRadians),
                    @"grad": @(kDimensionTypeGradians),
                    @"ms": @(kDimensionTypeMilliseconds),
                    @"s": @(kDimensionTypeSeconds),
                    @"Hz": @(kDimensionTypeHertz),
                    @"kHz": @(kDimensionTypeKilohertz),
                    @"%": @(kDimensionTypePercentage)};
}

#pragma mark - Static Initializers

+ (instancetype)dimensionWithNumber:(CGFloat)number withDimension:(NSString *)dimension
{
    return [[PXDimension alloc] initWithNumber:number withDimension:dimension];
}

#pragma mark - Initializers

- (instancetype)initWithNumber:(CGFloat)aNumber withDimension:(NSString *)aDimension
{
    if (self = [super init])
    {
        self->number = aNumber;
        self->dimension = aDimension;

        NSNumber *typeNumber = dimensionMap[aDimension];

        self->type = (typeNumber) ? typeNumber.intValue : kDimensionTypeUserDefined;
    }

    return self;
}

#pragma mark - Getters

- (BOOL)isLength
{
    switch (self->type)
    {
        case kDimensionTypePixels:
        case kDimensionTypeDevicePixels:
        case kDimensionTypeCentimeters:
        case kDimensionTypeMillimeters:
        case kDimensionTypeInches:
        case kDimensionTypePoints:
        case kDimensionTypePicas:
            return YES;

        default:
            return NO;
    }
}

- (BOOL)isAngle
{
    switch (self->type)
    {
        case kDimensionTypeDegrees:
        case kDimensionTypeRadians:
        case kDimensionTypeGradians:
            return YES;

        default:
            return NO;
    }
}

- (BOOL)isTime
{
    switch (self->type)
    {
        case kDimensionTypeMilliseconds:
        case kDimensionTypeSeconds:
            return YES;

        default:
            return NO;
    }
}

- (BOOL)isFrequency
{
    switch (self->type)
    {
        case kDimensionTypeHertz:
        case kDimensionTypeKilohertz:
            return YES;

        default:
            return NO;
    }
}

- (BOOL)isPercentage
{
    return self->type == kDimensionTypePercentage;
}

- (BOOL)isUserDefined
{
    return self->type == kDimensionTypeUserDefined;
}

- (PXDimension *)degrees
{
    CGFloat result = 0.0;

    switch (self->type)
    {
        case kDimensionTypeDegrees:
            result = self->number;
            break;

        case kDimensionTypeGradians:
            result = self->number * 0.9f;
            break;

        case kDimensionTypeRadians:
            result = RADIANS_TO_DEGREES(self->number);
            break;

        default:
            break;
    }

    return [PXDimension dimensionWithNumber:result withDimension:@"deg"];
}

- (PXDimension *)points
{
    CGFloat result = 0.0;

    switch (self->type)
    {
        case kDimensionTypePixels:
            result = self->number;
            break;

        case kDimensionTypeDevicePixels:
            result = self->number / [UIScreen mainScreen].scale;
            break;

        case kDimensionTypeCentimeters:
            result = self->number * 28.346456692913;
            break;

        case kDimensionTypeMillimeters:
            result = self->number * 2.8346456692913;
            break;

        case kDimensionTypeInches:
            result = self->number * 72;
            break;

        case kDimensionTypePoints:
            result = self->number;
            break;

        case kDimensionTypePicas:
            result = self->number * 12;
            break;

        default:
            break;
    }

    return [PXDimension dimensionWithNumber:result withDimension:@"pt"];
}

- (PXDimension *)radians
{
    CGFloat result = 0.0;

    switch (self->type)
    {
        case kDimensionTypeDegrees:
            result = DEGREES_TO_RADIANS(self->number);
            break;

        case kDimensionTypeGradians:
            result = self->number * 0.015707963267949f;
            break;

        case kDimensionTypeRadians:
            result = self->number;
            break;

        default:
            break;
    }

    return [PXDimension dimensionWithNumber:result withDimension:@"rad"];
}

#pragma mark - Overrides

- (void)dealloc
{
    self->dimension = nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%f%@", number, dimension];
}

@end
