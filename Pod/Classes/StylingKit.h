//
// Created by Anton Matosov [CTR] on 12/19/15.
//

#import <Foundation/Foundation.h>

@interface StylingKit : NSObject

- (instancetype)init NS_UNAVAILABLE;

/// Shared and only allowed instance of the StylingKit to be used in the app
+ (instancetype)sharedKit;

- (void)startStyling;

@end
