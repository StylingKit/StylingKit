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
//  PXAnimationInfo.h
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 3/5/13.
//  Copyright (c) 2013 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXKeyframe.h"

/**
 *  An enumeration indicating what type of timing function to use in an animation
 */
typedef NS_ENUM(int, PXAnimationTimingFunction)
{
    PXAnimationTimingFunctionUndefined = -1,
    PXAnimationTimingFunctionEase,          // ease [default]
    PXAnimationTimingFunctionLinear,        // linear
    PXAnimationTimingFunctionEaseIn,        // ease-in
    PXAnimationTimingFunctionEaseOut,       // ease-out
    PXAnimationTimingFunctionEaseInOut,     // ease-in-out
    PXAnimationTimingFunctionStepStart,     // step-start
    PXAnimationTimingFunctionStepEnd,       // step-end
                                            // steps(<integer>[, [ start | end ] ]?)
                                            // cubic-bezier(<number>, <number>, <number>, <number>)
};

/**
 *  An enumeration indicating the direction of an animation
 */
typedef NS_ENUM(int, PXAnimationDirection)
{
    PXAnimationDirectionUndefined = -1,
    PXAnimationDirectionNormal,             // normal [default]
    PXAnimationDirectionReverse,            // reverse
    PXAnimationDirectionAlternate,          // alternate
    PXAnimationDirectionAlternateReverse    // alternate-reverse
};

/**
 *  An enumeration indicating the current state of an animation
 */
typedef NS_ENUM(int, PXAnimationPlayState)
{
    PXAnimationPlayStateUndefined = -1,
    PXAnimationPlayStateRunning,            // running [default]
    PXAnimationPlayStatePaused              // paused
};

/**
 *  An enumeration indicating how an animation should fill its remaining time
 */
typedef NS_ENUM(int, PXAnimationFillMode)
{
    PXAnimationFillModeUndefined = -1,
    PXAnimationFillModeNone,                // none [default]
    PXAnimationFillModeForwards,            // forwards
    PXAnimationFillModeBackwards,           // backwards
    PXAnimationFillModeBoth                 // both
};

@interface PXAnimationInfo : NSObject

@property (nonatomic, strong) NSString *animationName;
@property (nonatomic) CGFloat animationDuration;
@property (nonatomic) PXAnimationTimingFunction animationTimingFunction;
@property (nonatomic) NSUInteger animationIterationCount;
@property (nonatomic) PXAnimationDirection animationDirection;
@property (nonatomic) PXAnimationPlayState animationPlayState;
@property (nonatomic) CGFloat animationDelay;
@property (nonatomic) PXAnimationFillMode animationFillMode;

@property (nonatomic, strong, readonly) PXKeyframe *keyframe;
@property (nonatomic, readonly, getter = isValid) BOOL valid;

- (instancetype)initWithCSSDefaults;

- (void)setUndefinedPropertiesWithAnimationInfo:(PXAnimationInfo *)info;

@end
