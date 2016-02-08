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
//  PXProxy.m
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Paul Colton on 11/22/13.
//  Copyright (c) 2013 Pixate, Inc. All rights reserved.
//
//  Insipiration from https://github.com/hoteltonight/HTDelegateProxy
//  and https://github.com/DDany/iOS-super-delegate-proxy

#import "PXProxy.h"

@interface PXProxy ()

@property (strong, nonatomic) NSMutableDictionary *respondsToSelectorCache;
@property (strong, nonatomic) NSMutableDictionary *methodSignatureForSelectorCache;

@end

@implementation PXProxy

#pragma mark - Initializer

- (instancetype)initWithBaseOject:(id)base overridingObject:(id)overrider
{
    self.baseObject = base;
    self.overridingObject = overrider;
    return self;
}

#pragma mark - NSProxy methods

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    NSString* sels = NSStringFromSelector(sel);
    id signature = self.methodSignatureForSelectorCache[sels];

    if (!signature)
    {
        signature = [self.overridingObject methodSignatureForSelector:sel];
        self.methodSignatureForSelectorCache[sels] = signature ?: [NSNull null];
    }

    if (!signature)
    {
        signature = [self.baseObject methodSignatureForSelector:sel];
        self.methodSignatureForSelectorCache[sels] = signature ?: [NSNull null];
    }

    return signature == [NSNull null] ? nil : signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    
    NSString *returnType = @(invocation.methodSignature.methodReturnType);
    
    BOOL voidReturnType = [returnType isEqualToString:@"v"];

    if ([self respondsToSelectorOverride:invocation.selector])
    {
        [invocation invokeWithTarget:self.overridingObject];
        
        // If the return type is NOT void, then we need to return first
        if (!voidReturnType)
        {
            return;
        }
    }
    
    if (self.baseObject && [self.baseObject respondsToSelector:invocation.selector])
    {
        [invocation invokeWithTarget:self.baseObject];
    }
}

- (BOOL)respondsToSelectorOverride:(SEL)sel
{
    NSString* sels = NSStringFromSelector(sel);
    NSNumber *respondsToSelector = self.respondsToSelectorCache[sels];
    BOOL responds = respondsToSelector.boolValue;

    if (!respondsToSelector)
    {
        responds = [self.overridingObject respondsToSelector:sel];
        self.respondsToSelectorCache[sels] = @(responds);
    }
    return responds;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([self respondsToSelectorOverride:aSelector]) return YES;
    if ([self.baseObject respondsToSelector:aSelector]) return YES;
    return NO;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    if ([self.overridingObject conformsToProtocol:aProtocol]) return YES;
    if ([self.baseObject conformsToProtocol:aProtocol]) return YES;
    return NO;
}

- (BOOL)isKindOfClass:(Class)aClass {
    if ([self.overridingObject isKindOfClass:aClass]) return YES;
    if ([self.baseObject isKindOfClass:aClass]) return YES;
    return NO;
}

#pragma mark - hash and equality

/// make sure we look like the original object

-(NSUInteger)hash
{
    return [self.baseObject hash];
}

-(BOOL)isEqual:(id)object
{
    return [self.baseObject isEqual:object];
}

- (NSMutableDictionary *)respondsToSelectorCache
{
    if (!_respondsToSelectorCache)
    {
        _respondsToSelectorCache = [NSMutableDictionary new];
    }
    return _respondsToSelectorCache;
}

- (NSMutableDictionary *)methodSignatureForSelectorCache
{
    if (!_methodSignatureForSelectorCache)
    {
        _methodSignatureForSelectorCache = [NSMutableDictionary new];
    }
    return _methodSignatureForSelectorCache;
}


@end
