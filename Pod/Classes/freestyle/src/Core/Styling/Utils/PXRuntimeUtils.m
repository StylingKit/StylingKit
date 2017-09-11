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
//  PXRuntimeUtils.m
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 3/20/13.
//  Copyright (c) 2013 Pixate, Inc. All rights reserved.
//

#import "PXRuntimeUtils.h"

#include <execinfo.h>
#include <stdio.h>

@implementation PXRuntimeUtils

+ (NSArray *)getLastCallers:(int)count
{
    NSMutableArray *callers = [[NSMutableArray alloc] init];

    // NOTE: Increase count by one since we omit the call to this method
    count++;

    void* callstack[count];
    int frames = backtrace(callstack, count);
    char** strs = backtrace_symbols(callstack, frames);

    // NOTE: start at 1 to skip the call to this method
    for (int i = 1; i < frames; ++i)
    {
        NSString *string = @(strs[i]);

        [callers addObject:string];
    }

    // We're responsible for free'ing the array returned by backtrace_symbols
    free(strs);

    return callers;
}

@end
