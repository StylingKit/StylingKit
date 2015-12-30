//
//  PXDOMAttribute.h
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 11/10/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXDOMAttribute : NSObject

@property (nonatomic, readonly) NSString *namespacePrefix;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, strong) id value;

- (instancetype) initWithName:(NSString *)name value:(id)value NS_DESIGNATED_INITIALIZER;

@end
