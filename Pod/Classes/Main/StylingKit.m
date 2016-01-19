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

#import "StylingKit.h"
#import "PixateFreestyle.h"
#import "PXStylesheet-Private.h"

@implementation StylingKit

+ (instancetype)sharedKit
{
    static id instance;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^
    {
        instance = [[self alloc] initPrivate];
    });

    return instance;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
    }

    return self;
}

- (void)startStyling
{
    @autoreleasepool
    {
        // Load default stylesheets and send notification
        NSString* defaultPath = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"css"];
        [PXStylesheet styleSheetFromFilePath:defaultPath withOrigin:PXStylesheetOriginApplication];

        NSString* userPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"css"];
        [PXStylesheet styleSheetFromFilePath:userPath withOrigin:PXStylesheetOriginUser];

        // Set default styling mode of any UIView to 'normal' (i.e. stylable)
        [UIView appearance].styleMode = PXStylingNormal;
    };
}

- (void)registerThemeNamed:(NSString*)themeName inBundle:(NSBundle*)bundle
{

}


@end
