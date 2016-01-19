//
// Created by Anton Matosov on 1/18/16.
//

#import "STKThemesRegistry.h"

static NSString* const kStylingKitThemes = @"StylingKitThemes";


@implementation STKThemesRegistry

+ (void)loadThemes
{
    NSArray* themeBundles = [self prv_findStylingKitThemes];
//    for (NSBundle* theme in themeBundles)
//    {
//        [[self sharedKit] registerThemeNamed:[self prv_nameFromBundleId:theme.bundleIdentifier]
//                                    inBundle:theme];
//    }
}

+ (NSArray*)prv_findStylingKitThemes
{
    NSMutableArray* result = [NSMutableArray new];
    for (NSBundle* bundle in [NSBundle allBundles])
    {
        if ([bundle.bundleIdentifier containsString:kStylingKitThemes])
        {
            [result addObject:bundle];
        }
    }

    for (NSBundle* framework in [NSBundle allFrameworks])
    {
        if ([framework.bundleIdentifier containsString:kStylingKitThemes])
        {
            NSArray* bundleURLs = [NSBundle URLsForResourcesWithExtension:@"bundle"
                                                             subdirectory:@""
                                                          inBundleWithURL:framework.bundleURL];
            for (NSURL* bundleURL in bundleURLs)
            {
                NSArray* cssURLs = [NSBundle URLsForResourcesWithExtension:@"css"
                                                              subdirectory:@""
                                                           inBundleWithURL:bundleURL];

                if (cssURLs.count > 0)
                {
                    [result addObject:[NSBundle bundleWithURL:bundleURL]];
                }
            }
        }
    }

    NSLog(@"Theme bundles: %@", result);
    return result;
}

+ (NSString*)prv_nameFromBundleId:(NSString*)identifier
{
    return nil;
}

@end
