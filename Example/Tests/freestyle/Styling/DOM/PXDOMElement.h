//
//  PXDOMElement.h
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 11/10/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXDOMNode.h"

@interface PXDOMElement : NSObject <PXDOMNode>

@property (nonatomic, readonly) NSString *innerXML;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name NS_DESIGNATED_INITIALIZER;

- (void)addNamespaceURI:(NSString *)URI forPrefix:(NSString *)prefix;
- (void)addChild:(id<PXDOMNode>)child;
- (id)attributeValueForName:(NSString *)name withNamespace:(NSString *)namespace;
- (void)setAttributeValue:(id)value forName:(NSString *)name;

@end
