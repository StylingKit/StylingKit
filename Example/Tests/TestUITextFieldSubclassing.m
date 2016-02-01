//
//  TestUITextFieldSubclassing.m
//  StylingKit
//
//  Created by Anton Matosov on 1/31/16.
//  Copyright (c) 2016 Anton Matosov. All rights reserved.
//

#import "PXStyleable.h"

@interface TestUITextFieldSubclassing : XCTestCase
@end

@implementation TestUITextFieldSubclassing

- (void)testRespondsToSelector
{
    UITextField *text = [UITextField new];

    expect([text respondsToSelector:@selector(preventStyling)]).to.beFalsy();
    expect([text respondsToSelector:@selector(keyboardAppearance)]).to.beTruthy();
    expect([text respondsToSelector:NSSelectorFromString(@"nonExistingMethod")]).to.beFalsy();
}


@end
