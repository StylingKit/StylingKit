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
//  PXFontRegistry.m
//  Pixate
//
//  Created by Kevin Lindsey on 9/21/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import "PXFontRegistry.h"
#import "PXFontEntry.h"
#import <CoreText/CTFontManager.h>

@implementation PXFontRegistry

static NSMutableDictionary *REGISTRY;
static NSCache *FONT_CACHE;
static NSMutableSet *LOADED_FONTS;

+ (void)initialize
{
    if (!REGISTRY)
    {
        REGISTRY = [[NSMutableDictionary alloc] init];
        LOADED_FONTS = [[NSMutableSet alloc] init];
    }
}

+ (void)clearRegistry
{
    [REGISTRY removeAllObjects];
}

+ (UIFont*)fontWithFamily:(NSString*)family
              fontStretch:(NSString*)stretch
               fontWeight:(NSString*)weight
                fontStyle:(NSString*)style
                     size:(CGFloat)size
            isDefaultFont:(BOOL)isDefaultFont
{
    NSString *key = [self keyFromFamily:family stretch:stretch weight:weight style:style];

    UIFont *result = [self fontFromCacheWithKey:key];
    if (result)
    {
        return result;
    }

    id resultingFontName = REGISTRY[key];

    if (!resultingFontName)
    {
        NSArray *infos = [PXFontEntry fontEntriesForFamily:family];
        infos = [PXFontEntry filterEntries:infos byStretch:[PXFontEntry indexFromStretchName:stretch]];
        infos = [PXFontEntry filterEntries:infos byStyle:style];
        infos = [PXFontEntry filterEntries:infos byWeight:[PXFontEntry indexFromWeightName:weight]];

        // save result so won't do the rather expensive lookup process again
        if (infos.count > 0)
        {
            PXFontEntry *info = infos[0];

            resultingFontName = info.name;
        }
        else if (isDefaultFont)
        {
//            UIKIT_EXTERN const CGFloat UIFontWeightUltraLight NS_AVAILABLE_IOS(8_2);
//            UIKIT_EXTERN const CGFloat UIFontWeightThin NS_AVAILABLE_IOS(8_2);
//            UIKIT_EXTERN const CGFloat UIFontWeightLight NS_AVAILABLE_IOS(8_2);
//            UIKIT_EXTERN const CGFloat UIFontWeightRegular NS_AVAILABLE_IOS(8_2);
//            UIKIT_EXTERN const CGFloat UIFontWeightMedium NS_AVAILABLE_IOS(8_2);
//            UIKIT_EXTERN const CGFloat UIFontWeightSemibold NS_AVAILABLE_IOS(8_2);
//            UIKIT_EXTERN const CGFloat UIFontWeightBold NS_AVAILABLE_IOS(8_2);
//            UIKIT_EXTERN const CGFloat UIFontWeightHeavy NS_AVAILABLE_IOS(8_2);
//            UIKIT_EXTERN const CGFloat UIFontWeightBlack NS_AVAILABLE_IOS(8_2);

            if (![@"italic" isEqualToString:style] ||
                [@"oblique" isEqualToString:style])
            {
                result = [UIFont italicSystemFontOfSize:size];

                id fd = [result.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic ];
                result = [UIFont fontWithDescriptor:fd
                                               size:size];
            }
            else
            {
                result = [UIFont systemFontOfSize:size];
            }
        }
        else
        {
            // store an NSNull as a surrogate for nil
            resultingFontName = [NSNull null];
        }

        REGISTRY[key] = resultingFontName;
    }

    if (resultingFontName &&
        resultingFontName != [NSNull null])
    {
        static int count = 0;
        NSLog(@"fontWithName: %i, key: %@, res: %@, %f", ++count, key, resultingFontName, size);

        result = [UIFont fontWithName:resultingFontName size:size];
    }

    if (result)
    {
        [self storeFont:result
                withKey:key];
    }
    return result;
}

+ (UIFont *)fontFromCacheWithKey:(NSString*)key
{
    return [FONT_CACHE objectForKey:key];
}

+ (void)storeFont:(UIFont *)font
          withKey:(NSString*)key
{
    [FONT_CACHE setObject:font forKey:key];
}

+ (NSString *)keyFromFamily:(NSString *)family stretch:(NSString *)stretch weight:(NSString *)weight style:(NSString *)style
{
    return [NSString stringWithFormat:@"%@:%@:%@:%@", family, stretch, weight, style];
}

+ (void)loadFontFromURL:(NSURL *)URL
{
    if (URL != nil && ![LOADED_FONTS containsObject:URL])
    {
        [LOADED_FONTS addObject:URL];

        NSData *data = [NSData dataWithContentsOfURL:URL];

        if (data != nil)
        {
            CFErrorRef error;
            CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
            CGFontRef font = CGFontCreateWithDataProvider(provider);

            if (!CTFontManagerRegisterGraphicsFont(font, &error))
            {
                CFStringRef errorDescription = CFErrorCopyDescription(error);
                NSLog(@"Failed to load font: %@", errorDescription);
                CFRelease(errorDescription);
            }

            CFRelease(font);
            CFRelease(provider);
        }
    }
}

@end
