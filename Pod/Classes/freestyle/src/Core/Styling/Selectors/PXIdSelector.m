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
//  PXIdSelector.m
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 7/9/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import "PXIdSelector.h"
#import "PXStyleable.h"
#import "PXSpecificity.h"
#import "PXStyleUtils.h"
#import "PXLog.h"

@implementation PXIdSelector

STK_DEFINE_CLASS_LOG_LEVEL

#pragma mark - Initializers

- (instancetype)initWithIdValue:(NSString *)value
{
    if (self = [super init])
    {
        _idValue = value;
    }

    return self;
}

#pragma mark - Methods

- (void)incrementSpecificity:(PXSpecificity *)specificity
{
    [specificity incrementSpecifity:kSpecificityTypeId];
}

- (BOOL)matches:(id<PXStyleable>)element
{
    BOOL result = [_idValue isEqualToString:element.styleId];

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

#pragma mark - PXSourceEmitter Methods

- (void)sourceWithSourceWriter:(id)writer
{
    [writer printIndent];
    [writer print:@"(ID #"];
    [writer print:_idValue];
    [writer print:@")"];
    [writer printNewLine];
}

#pragma mark - Overrides

- (NSString *)description
{
    return [NSString stringWithFormat:@"#%@", _idValue];
}

@end
