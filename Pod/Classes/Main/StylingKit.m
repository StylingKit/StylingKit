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

#if STK_CLOUD
#   import "STKCloud.h"
#endif

#import "StylingKit.h"
#import "PixateFreestyle.h"
#import "PXStylesheet-Private.h"
#import "STKTheme.h"
#import "STKThemesRegistry.h"
#import "STK_UIAlertControllerView.h"
#import "PXLoggingUtils.h"
#import "PXStylesheetParser.h"
#import "PXStyleUtils.h"
#import "STStyleable.H"
#import "PXClassSelector.h"
#import "UIView+PXStyling.h"

@interface StylingKit ()

@property(strong, nonatomic) NSMutableDictionary* themes;

@end

@implementation StylingKit

STK_DEFINE_CLASS_LOG_LEVEL;


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

- (STKCloud*)cloud
{
#if STK_CLOUD
    return [STKCloud defaultCloud];
#else
    return nil;
#endif
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
        [STKThemesRegistry loadThemes];

        for (STKTheme* theme in self.themes.allValues)
        {
            if ([theme activate])
            {
                _currentTheme = theme;
                break;
            }
        }

        [UIView appearanceWhenContainedIn:[UIDatePicker class], [STK_UIAlertControllerView targetSuperclass], nil].styleMode = PXStylingNone;


        // Set default styling mode of any UIView to 'normal' (i.e. stylable)
        [UIView appearance].styleMode = PXStylingNormal;
    }
}

- (STKTheme*)registerThemeNamed:(NSString*)themeName
                       inBundle:(NSBundle*)bundle
{
    return [self registerThemeNamed:themeName stylesheetFileName:nil inBundle:bundle];
}

- (STKTheme*)registerThemeNamed:(NSString*)themeName
             stylesheetFileName:(NSString*)stylesheetFileName
                       inBundle:(NSBundle*)bundle
{
    
    
    
    if (self.themes[themeName])
    {
        DDLogWarn(@"Theme with name %@ already registered. %@", themeName, self.themes[themeName]);
    }
    STKTheme* theme = [STKTheme themeWithName:themeName
                           stylesheetFileName:(NSString*)stylesheetFileName
                                       bundle:bundle];
    
    self.themes[themeName] = theme;
    
    return theme;
}
- (NSString*)getStyleValueWithClass:(NSString*)className propertyName:(NSString*) propertyName {
    
    STStyleable *stylable = [[STStyleable alloc] init];
    [stylable setStyleClass:className];

    NSMutableArray *ruleSets = [PXStyleUtils matchingRuleSetsForStyleable:stylable];
    
    for (PXRuleSet *ruleSet in ruleSets)
    {
        for(PXDeclaration *dec in ruleSet.declarations){
            if([[dec name] isEqualToString:propertyName]){
                return [dec stringValue];
            }
        }
    }
    
    return nil;
}
- (NSDictionary*)getStylesWithClass:(NSString*)className {
    
    NSMutableDictionary *styles = [NSMutableDictionary dictionary];
    
    STStyleable *stylable = [[STStyleable alloc] init];
    [stylable setStyleClass:className];
    
    NSMutableArray *ruleSets = [PXStyleUtils matchingRuleSetsForStyleable:stylable];
    
    for (PXRuleSet *ruleSet in ruleSets)
    {
        for(PXDeclaration *dec in ruleSet.declarations){
            [styles setValue:[dec stringValue] forKey:[dec name]];
        }
    }
    
    return styles;
}
@end
