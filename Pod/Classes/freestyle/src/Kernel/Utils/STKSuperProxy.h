//
// Created by Anton Matosov on 2/1/16.
//

#import <Foundation/Foundation.h>

@interface STKSuperProxy : NSProxy
{
@public
    __weak id _object;
}

- (id)initWithObject:(id<NSObject>)object;

@end
