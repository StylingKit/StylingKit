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
//  PXChildCombinator.m
//  Pixate
//
//  Created by Kevin Lindsey on 9/25/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import "PXChildCombinator.h"
#import "PXStyleUtils.h"

@implementation PXChildCombinator

STK_DEFINE_CLASS_LOG_LEVEL

#pragma mark - Getters

- (NSString *)displayName
{
    return @"CHILD_COMBINATOR";
}

#pragma mark - Methods

- (BOOL)matches:(id<PXStyleable>)element
{
    BOOL result = NO;

    if ([self.rhs matches:element])
    {
        id parent = element.pxStyleParent;

        if ([parent conformsToProtocol:@protocol(PXStyleable)])
        {
            id<PXStyleable> styleableParent = parent;

            result = [self.lhs matches:styleableParent];
        }
    }

    if (result)
    {
        DDLogVerbose(@"%@ matched %@", self.description, [PXStyleUtils descriptionForStyleable:element]);
    }
    else
    {
        DDLogVerbose(@"%@ did not match %@", self.description, [PXStyleUtils descriptionForStyleable:element]);
    }

    return result;
}

#pragma mark - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ > %@", self.lhs, self.rhs];
}

@end
