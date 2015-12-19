//
// Created by Anton Matosov [CTR] on 12/19/15.
//

#import "StylingKit.h"
#import "PixateFreestyle.h"

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
    [PixateFreestyle initializePixateFreestyle];
}

@end
