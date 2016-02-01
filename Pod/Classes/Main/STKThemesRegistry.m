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
// Created by Anton Matosov on 1/18/16.
//

#import "STKThemesRegistry.h"
#import "NSMutableArray+QueueAdditions.h"
#import "StylingKit.h"


@implementation STKThemesRegistry

+ (void)loadThemes
{
    NSArray* themeBundles = [self prv_findStylingKitThemes];
    for (NSBundle* themeBundle in themeBundles)
    {
        [[StylingKit sharedKit] registerThemeNamed:[self prv_themeNameFromBundle:themeBundle]
                                          inBundle:themeBundle];
    }
}

+ (NSArray*)prv_findStylingKitThemes
{
    NSMutableArray* result = [NSMutableArray new];

    [result addObjectIfNotNil:[self prv_themeBundleAtURL:[NSBundle mainBundle].bundleURL]];

    for (NSBundle* bundle in [NSBundle allBundles])
    {
        [result addObjectIfNotNil:[self prv_themeBundleAtURL:bundle.bundleURL]];
    }

    for (NSBundle* framework in [NSBundle allFrameworks])
    {
        if ([framework.bundleIdentifier containsString:@"StylingKitThemes"])
        {
            NSArray* bundleURLs = [NSBundle URLsForResourcesWithExtension:@"bundle"
                                                             subdirectory:@""
                                                          inBundleWithURL:framework.bundleURL];
            for (NSURL* bundleURL in bundleURLs)
            {
                [result addObjectIfNotNil:[self prv_themeBundleAtURL:bundleURL]];
            }
        }
    }

    return result;
}

+ (NSBundle*)prv_themeBundleAtURL:(NSURL*)bundleURL
{
    NSBundle* bundle;
    NSArray* cssURLs = [NSBundle URLsForResourcesWithExtension:@"css"
                                                  subdirectory:@""
                                               inBundleWithURL:bundleURL];

    if (cssURLs.count > 0)
    {
        bundle = [NSBundle bundleWithURL:bundleURL];
    }
    return bundle;
}

+ (NSString*)prv_themeNameFromBundle:(NSBundle*)themeBundle
{
    NSString* bundleName = themeBundle.bundlePath.lastPathComponent.stringByDeletingPathExtension;

    return bundleName;
}

@end
