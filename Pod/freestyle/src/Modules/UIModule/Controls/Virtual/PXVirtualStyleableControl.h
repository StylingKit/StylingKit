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
//  PXVirtualControlBase.h
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 10/16/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXVirtualControl.h"
#import "PXStylerContext.h"

typedef void(^PXViewStyleUpdaterBlock)(PXRuleSet *ruleSet, PXStylerContext *context);

@interface PXVirtualStyleableControl : NSObject <PXVirtualControl>

@property (nonatomic, copy) NSArray *pxStyleChildren;
@property (nonatomic, copy) NSArray *viewStylers;
@property (nonatomic, copy) NSArray *supportedPseudoClasses;
@property (nonatomic, copy) NSString *defaultPseudoClass;
@property (nonatomic, weak) CALayer *layer;

- (instancetype)initWithParent:(id<PXStyleable>)parent elementName:(NSString *)elementName;
- (instancetype)initWithParent:(id<PXStyleable>)parent elementName:(NSString *)elementName viewStyleUpdaterBlock:(PXViewStyleUpdaterBlock)block NS_DESIGNATED_INITIALIZER;

@end
