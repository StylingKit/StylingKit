//
//  PXDOMText.h
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 11/10/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXDOMNode.h"

@interface PXDOMText : NSObject <PXDOMNode>

@property (nonatomic, readonly) NSString *textValue;

- (instancetype) initWithText:(NSString *)text NS_DESIGNATED_INITIALIZER;

@end
