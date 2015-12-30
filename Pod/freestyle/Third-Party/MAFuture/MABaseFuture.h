
//  Modified by Anton Matosov on 12/30/15.

#import <Foundation/Foundation.h>

#import "MAProxy.h"


@interface MABaseFuture : MAProxy
{
    id _value;
    NSCondition *_lock;
    BOOL _resolved;
}

- (instancetype)init;

// access value while holding the lock
// don't call the setter more than once
@property (NS_NONATOMIC_IOSONLY, strong) id futureValue;

// if you lock manually, you can use this
- (void)setFutureValueUnlocked: (id)value;

// checks to see if setFutureValue: has been called yet
// lock the lock first for best results
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL futureHasResolved;

// if setFutureValue: has not been called yet, blocks until it has
// returns _value
@property (NS_NONATOMIC_IOSONLY, readonly, strong) id waitForFutureResolution;

// subclasses must implement! don't call super!
// returns the future value, blocks for it to resolve if needed
@property (NS_NONATOMIC_IOSONLY, readonly, strong) id resolveFuture;

@end
