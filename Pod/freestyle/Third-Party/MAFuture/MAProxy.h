
//  Modified by Anton Matosov on 12/30/15.

@interface MAProxy : NSObject
{
    int32_t _refcountMinusOne;
}

+ (id)alloc;
- (void)dealloc;

- (void)finalize;
@property (NS_NONATOMIC_IOSONLY, getter=isProxy, readonly) BOOL proxy;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) id retain;
- (void)release;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) id autorelease;
@property (NS_NONATOMIC_IOSONLY, readonly) NSUInteger retainCount;

@end

