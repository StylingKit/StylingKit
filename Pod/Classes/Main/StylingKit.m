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
#import "STKTheme.h"

@interface StylingKit ()

@property(strong, nonatomic) NSMutableDictionary* themes;

@end

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

- (NSMutableDictionary*)themes
{
    if (!_themes)
    {
        _themes = [NSMutableDictionary new];
    }
    return _themes;
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
        STKTheme* appTheme = [self registerThemeNamed:@"default"
                                             inBundle:[NSBundle mainBundle]];

        STKTheme* userTheme = [self registerThemeNamed:@"user"
                                              inBundle:[NSBundle mainBundle]];
        userTheme.stylesheetFileName = userTheme.name;
        userTheme.origin = PXStylesheetOriginUser;

        [appTheme activate];
        [userTheme activate];

        // Set default styling mode of any UIView to 'normal' (i.e. stylable)
        [UIView appearance].styleMode = PXStylingNormal;
    };
}

- (STKTheme*)registerThemeNamed:(NSString*)themeName
                       inBundle:(NSBundle*)bundle
{
    if (self.themes[themeName])
    {
        DDLogWarn(@"Theme with name %@ already registered. %@", themeName, self.themes[themeName]);
    }
    STKTheme* theme = [STKTheme themeWithName:themeName
                                       bundle:bundle];
    self.themes[themeName] = theme;

    return theme;
}

@end
