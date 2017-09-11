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
//  PXPseudoClassSelector.m
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 9/1/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import "PXPseudoClassSelector.h"
#import "PXSpecificity.h"
#import "PXStyleable.h"
#import "PXStyleUtils.h"

@implementation PXPseudoClassSelector
{
    NSString *className;
}

@synthesize className;

STK_DEFINE_CLASS_LOG_LEVEL

#pragma mark - Initializers

- (instancetype)initWithClassName:(NSString *)name
{
    if (self = [super init])
    {
        self->className = name;
    }

    return self;
}

#pragma mark - Methods

- (void)incrementSpecificity:(PXSpecificity *)specificity
{
    [specificity incrementSpecifity:kSpecificityTypeClassOrAttribute];
}

- (BOOL)matches:(id<PXStyleable>)element
{
    BOOL result = NO;

    if ([element respondsToSelector:@selector(supportedPseudoClasses)])
    {
        result = ([element.supportedPseudoClasses indexOfObject:className] != NSNotFound);
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
    return [NSString stringWithFormat:@":%@", className];
}

@end
