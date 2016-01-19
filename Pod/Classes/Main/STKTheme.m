//
// Created by Anton Matosov on 1/18/16.
//

#import "STKTheme.h"

@implementation STKTheme

- (instancetype)initWithName:(NSString*)name
          stylesheetFileName:(NSString*)stylesheetFileName
                      bundle:(NSBundle*)bundle
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.stylesheetFileName = stylesheetFileName ?: @"default";
        self.bundle = bundle;
    }

    return self;
}

+ (instancetype)themeWithName:(NSString*)name
           stylesheetFileName:(NSString*)stylesheetFileName
                       bundle:(NSBundle*)bundle
{
    return [[self alloc] initWithName:name
                   stylesheetFileName:stylesheetFileName
                               bundle:bundle];
}


+ (instancetype)themeWithName:(NSString*)name
                       bundle:(NSBundle*)bundle
{
    return [[self alloc] initWithName:name
                   stylesheetFileName:nil
                               bundle:bundle];
}

@end
