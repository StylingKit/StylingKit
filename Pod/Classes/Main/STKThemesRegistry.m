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
