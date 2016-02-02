//
// Created by Anton Matosov on 2/1/16.
//

#import <objc/runtime.h>
#include <objc/message.h>
#import "STKSuperProxy.h"
#import "NSObject+PXClass.h"

@implementation STKSuperProxy

- (id)initWithObject:(id<NSObject>)object
{
    self->_object = object;
    return self;
}

- (struct objc_super)superStruct
{
    Class superClass = [self->_object pxClass];
    struct objc_super superObj;
    superObj.receiver = self->_object;
    superObj.super_class = superClass != NULL ? superClass : class_getSuperclass(object_getClass(self->_object));

    return superObj;
}

typedef void* (* FnCallSuper0)(struct objc_super* super, SEL _cmd);
typedef void* (* FnCallSuper1)(struct objc_super* super, SEL _cmd, void*);
typedef void* (* FnCallSuper2)(struct objc_super* super, SEL _cmd, void*, void*);
typedef void* (* FnCallSuper3)(struct objc_super* super, SEL _cmd, void*, void*, void*);
typedef void* (* FnCallSuper4)(struct objc_super* super, SEL _cmd, void*, void*, void*, void*);
typedef void* (* FnCallSuper5)(struct objc_super* super, SEL _cmd, void*, void*, void*, void*, void*);
typedef void* (* FnCallSuper6)(struct objc_super* super, SEL _cmd, void*, void*, void*, void*, void*, void*);


- (void)forwardInvocation:(NSInvocation*)invocation
{
    static const int firstArgumentOffset = 2;
    NSMethodSignature* signature = invocation.methodSignature;
    NSUInteger numberOfArguments = signature.numberOfArguments - firstArgumentOffset;
    void* args[numberOfArguments];
    for (int index = 0; index < numberOfArguments; ++index)
    {
        [invocation getArgument:args + index
                        atIndex:index + firstArgumentOffset];
    }

    struct objc_super objcSuper = self.superStruct;

    void* result = 0;
    switch (numberOfArguments)
    {
        case 0:
            result = ((FnCallSuper0)objc_msgSendSuper)(&objcSuper, invocation.selector);
            break;

        case 1:
            result = ((FnCallSuper1)objc_msgSendSuper)(&objcSuper, invocation.selector, args[0]);
            break;

        case 2:
            result = ((FnCallSuper2)objc_msgSendSuper)(&objcSuper, invocation.selector, args[0], args[1]);
            break;

        case 3:
            result = ((FnCallSuper3)objc_msgSendSuper)(&objcSuper, invocation.selector, args[0], args[1], args[2]);
            break;

        case 4:
            result = ((FnCallSuper4)objc_msgSendSuper)(&objcSuper,
                                                       invocation.selector,
                                                       args[0],
                                                       args[1],
                                                       args[2],
                                                       args[3]);
            break;

        case 5:
            result = ((FnCallSuper5)objc_msgSendSuper)(&objcSuper,
                                                       invocation.selector,
                                                       args[0],
                                                       args[1],
                                                       args[2],
                                                       args[3],
                                                       args[4]);
            break;

        case 6:
            result = ((FnCallSuper6)objc_msgSendSuper)(&objcSuper,
                                                       invocation.selector,
                                                       args[0],
                                                       args[1],
                                                       args[2],
                                                       args[3],
                                                       args[4],
                                                       args[5]);
            break;

        default:
            NSAssert(NO,
                     @"Proxying calls to STK_super Not implemented for %lu arguments",
                     (unsigned long)numberOfArguments);
            break;
    }

    if (signature.methodReturnLength > 0)
    {
        [invocation setReturnValue:result];
    }
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)sel
{
    return [self->_object methodSignatureForSelector:sel];
}

@end
