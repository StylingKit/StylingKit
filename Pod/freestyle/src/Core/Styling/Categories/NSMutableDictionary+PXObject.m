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
//  NSMutableDictionary+PXObject.m
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 3/26/13.
//  Copyright (c) 2013 Pixate, Inc. All rights reserved.
//

#import "NSMutableDictionary+PXObject.h"
#import "PXValue.h"

void PXForceLoadNSMutableDictionaryPXObject() {}

@implementation NSMutableDictionary (PXObject)

- (void)setNilableObject:(id)object forKey:(id<NSCopying>)key
{
    id nilableObject = (object == nil) ? [NSNull null] : object;

    self[key] = nilableObject;
}

- (void)setRect:(CGRect)rect forKey:(id<NSCopying>)key
{
    PXValue *value = [[PXValue alloc] initWithBytes:&rect type:PXValueType_CGRect];

    self[key] = value;
}

- (void)setFloat:(CGFloat)floatValue forKey:(id<NSCopying>)key
{
    PXValue *value = [[PXValue alloc] initWithBytes:&floatValue type:PXValueType_CGFloat];

    self[key] = value;
}

- (void)setColorRef:(CGColorRef)colorRef forKey:(id<NSCopying>)key
{
    PXValue *value = [[PXValue alloc] initWithBytes:&colorRef type:PXValueType_CGColorRef];

    self[key] = value;
}

- (void)setSize:(CGSize)size forKey:(id<NSCopying>)key
{
    PXValue *value = [[PXValue alloc] initWithBytes:&size type:PXValueType_CGSize];

    self[key] = value;
}

- (void)setBoolean:(BOOL)booleanValue forKey:(id<NSCopying>)key
{
    PXValue *value = [[PXValue alloc] initWithBytes:&booleanValue type:PXValueType_Boolean];

    self[key] = value;
}

- (void)setTransform:(CGAffineTransform)transform forKey:(id<NSCopying>)key
{
    PXValue *value = [[PXValue alloc] initWithBytes:&transform type:PXValueType_CGAffineTransform];

    self[key] = value;
}

- (void)setInsets:(UIEdgeInsets)insets forKey:(id<NSCopying>)key
{
    PXValue *value = [[PXValue alloc] initWithBytes:&insets type:PXValueType_UIEdgeInsets];

    self[key] = value;
}

- (void)setLineBreakMode:(NSLineBreakMode)mode forKey:(id<NSCopying>)key
{
    PXValue *value = [[PXValue alloc] initWithBytes:&mode type:PXValueType_NSLineBreakMode];

    self[key] = value;
}

- (void)setTextAlignment:(NSTextAlignment)alignment forKey:(id<NSCopying>)key
{
    PXValue *value = [[PXValue alloc] initWithBytes:&alignment type:PXValueType_NSTextAlignment];
    
    self[key] = value;
}
@end
