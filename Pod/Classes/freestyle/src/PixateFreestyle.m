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
//  PixateFreestyle.m
//
//  Modified by Anton Matosov on 12/21/15.
//  Created by Paul Colton on 12/11/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import "PixateFreestyle.h"
#import "PixateFreestyle-Private.h"
#import "Freestyle-Version.h"

#import "PXStylesheet.h"
#import "PXStylesheet-Private.h"
#import "UIView+PXStyling.h"
#import "PXStylesheetParser.h"
#import "PXStyleUtils.h"
#import "PixateFreestyleConfiguration.h"
#import "PXStylerContext.h"
#import "PXCacheManager.h"

#import "PXForceLoadPixateCategories.h"
#import "PXForceLoadStylingCategories.h"
#import "PXForceLoadVirtualCategories.h"
#import "PXForceLoadControls.h"
#import "PXForceLoadCGCategories.h"

static void getMonthDayYear(NSDate *date, NSInteger *month_p, NSInteger *day_p, NSInteger *year_p)
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];

    *month_p = components.month;
    *day_p   = components.day;
    *year_p  = components.year;
}

@implementation PixateFreestyle
{
    BOOL _refreshStylesWithOrientationChange;
}

STK_DEFINE_CLASS_LOG_LEVEL;

+ (void)load
{
    [super load];

    //
    // These are required so we don't have to require a -ObjC flag on the project
    //
    
    // Trigger categories to all load
    [PXForceLoadPixateCategories forceLoad];
    [PXForceLoadStylingCategories forceLoad];
    [PXForceLoadVirtualCategories forceLoad];
    [PXForceLoadCGCategories forceLoad];
    
    // Trigger our UI subclasses to load
    [PXForceLoadControls forceLoad];
}

+ (void)initialize
{
    [super initialize];

    //
    // Print version info on first run (and check for Titanium mode)
    //
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,
        ^{
            NSInteger month, day, year;

            // Get main info dictionary that keeps plist properties
            NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;

            // Check for Titanium mode
            if(infoDictionary && infoDictionary[@"PXTitanium"])
            {
                [PixateFreestyle sharedInstance].titaniumMode =
                    [infoDictionary[@"PXTitanium"] boolValue];
            }

            getMonthDayYear([PixateFreestyle sharedInstance].buildDate, &month, &day, &year);

            // Print build info
            DDLogVerbose(@"Pixate Freestyle v%@ (API %d) %@- Build %ld/%02ld/%02ld",
                [PixateFreestyle sharedInstance].version,
                [PixateFreestyle sharedInstance].apiVersion,
                [PixateFreestyle sharedInstance].titaniumMode ? @"Titanium " : @"",
                (long) year, (long) month, (long) day);


        });
}

+ (PixateFreestyle *)sharedInstance
{
	static __strong PixateFreestyle *sharedInstance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[PixateFreestyle alloc] init];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MMM d yyyy";
        NSLocale *localeUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        dateFormatter.locale = localeUS;
        NSDate *date = [dateFormatter dateFromString:@__DATE__];
        sharedInstance->_buildDate = date;
        sharedInstance->_version = @PIXATE_FREESTYLE_VERSION;
        sharedInstance->_apiVersion = PIXATE_FREESTYLE_API_VERSION;
	});

	return sharedInstance;
}

+(NSString *)version
{
    return [PixateFreestyle sharedInstance].version;
}

+(NSDate *)buildDate
{
    return [PixateFreestyle sharedInstance].buildDate;
}

+ (int)apiVersion
{
    return [PixateFreestyle sharedInstance].apiVersion;
}

+(BOOL)titaniumMode
{
    return [PixateFreestyle sharedInstance].titaniumMode;
}

+(PixateFreestyleConfiguration *)configuration
{
    return [PixateFreestyle sharedInstance].configuration;
}

+(BOOL)refreshStylesWithOrientationChange
{
    return [PixateFreestyle sharedInstance]->_refreshStylesWithOrientationChange;
}

+(void)setRefreshStylesWithOrientationChange:(BOOL)value
{
    [[PixateFreestyle sharedInstance] internalSetRefreshStylesWithOrientationChange:value];
}

+ (NSArray *)selectFromStyleable:(id<PXStyleable>)styleable usingSelector:(NSString *)source
{
    PXStylesheetParser *parser = [[PXStylesheetParser alloc] init];
    id<PXSelector> selector = [parser parseSelectorString:source];
    NSMutableArray *result = nil;

    if (selector && parser.errors.count == 0)
    {
        result = [NSMutableArray array];

        [PXStyleUtils enumerateStyleableAndDescendants:styleable usingBlock:^(id<PXStyleable> obj, BOOL *stop, BOOL *stopDescending) {
            if ([selector matches:obj])
            {
                [result addObject:obj];
            }
        }];
    }

    return result;
}

+ (NSString *)matchingRuleSetsForStyleable:(id<PXStyleable>)styleable
{
    NSArray *ruleSets = [PXStyleUtils matchingRuleSetsForStyleable:styleable];
    NSMutableArray *stringValues = [NSMutableArray arrayWithCapacity:ruleSets.count];

    for (id<NSObject> ruleSet in ruleSets)
    {
        [stringValues addObject:ruleSet.description];
    }

    return [stringValues componentsJoinedByString:@"\n"];
}

+ (NSString *)matchingDeclarationsForStyleable:(id<PXStyleable>)styleable
{
    NSArray *ruleSets = [PXStyleUtils matchingRuleSetsForStyleable:styleable];
    PXRuleSet *mergedRuleSet = [PXRuleSet ruleSetWithMergedRuleSets:ruleSets];
    NSMutableArray *declarationStrings = [NSMutableArray arrayWithCapacity:mergedRuleSet.declarations.count];

    for (id<NSObject> declaration in mergedRuleSet.declarations)
    {
        [declarationStrings addObject:declaration.description];
    }

    return [declarationStrings componentsJoinedByString:@"\n"];
}

+ (instancetype)styleSheetFromFilePath:(NSString *)filePath withOrigin:(PXStylesheetOrigin)origin
{
    return [PXStylesheet styleSheetFromFilePath:filePath withOrigin:origin];
}

+ (instancetype)styleSheetFromSource:(NSString *)source withOrigin:(PXStylesheetOrigin)origin
{
    return [PXStylesheet styleSheetFromSource:source withOrigin:origin];
}

+ (PXStylesheet *)currentApplicationStylesheet
{
    return [PXStylesheet currentApplicationStylesheet];
}

+ (PXStylesheet *)currentUserStylesheet
{
    return [PXStylesheet currentUserStylesheet];
}

+ (PXStylesheet *)currentViewStylesheet
{
    return [PXStylesheet currentViewStylesheet];
}

+ (void)applyStylesheets
{
    [self updateStylesForAllViews];
}

+ (void)updateStylesForAllViews
{
    [[UIApplication sharedApplication].windows enumerateObjectsUsingBlock:^(UIWindow *window, NSUInteger index, BOOL *stop)
    {
        if([self titaniumMode])
        {
            [window.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
                // Style the first Ti* named view we find, the rest should be recursive from that one
                if([[[view class] description] hasPrefix:@"Ti"])
                {
                    [view updateStylesAsync];
                    *stop = YES;
                }
            }];
        }
        else
        {
            [window updateStylesAsync];
        }
    }];
}

+ (void)updateStyles:(id<PXStyleable>)styleable
{
    [styleable updateStyles];
}

+ (void)updateStylesNonRecursively:(id<PXStyleable>)styleable
{
    [styleable updateStylesNonRecursively];
}

+ (void)updateStylesAsync:(id<PXStyleable>)styleable
{
    [styleable updateStylesAsync];
}

+ (void)updateStylesNonRecursivelyAsync:(id<PXStyleable>)styleable
{
    [styleable updateStylesNonRecursivelyAsync];
}

+ (void)clearImageCache
{
    [PXCacheManager clearImageCache];
}

+ (void)clearStyleCache
{
    [PXCacheManager clearStyleCache];
}

#pragma mark - Initializers

- (instancetype)init
{
    if (self = [super init])
    {
        _configuration = [[PixateFreestyleConfiguration alloc] init];
    }

    return self;
}

#pragma mark - Properties (and Overrides)

-(void)internalSetRefreshStylesWithOrientationChange:(BOOL)val
{
    if(val && _refreshStylesWithOrientationChange)
    {
        // Prevent listening more than once at a time
        return;
    }

    if(val == YES)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationWillChangeNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }

    _refreshStylesWithOrientationChange = val;
}

#pragma mark - Methods

- (void)orientationWillChangeNotification:(NSNotification *)notification
{
    /*
    UIInterfaceOrientation nextOrientation = [[notification.userInfo
                                               objectForKey:UIApplicationStatusBarOrientationUserInfoKey] intValue];
     NSLog(@"Rotate! %d", nextOrientation);
    */

    [PXCacheManager clearStyleCache];
    [PXStylesheet clearCache];

    UIWindow* keyWindow = [UIApplication sharedApplication].keyWindow;
    if (keyWindow.styleMode != PXStylingNormal)
        keyWindow.styleMode = PXStylingNormal;
    [keyWindow updateStyles];
}

@end
