//
//  TestSuperProxy.m
//  StylingKit
//
//  Created by Anton Matosov on 2/1/16.
//  Copyright (c) 2016 Anton Matosov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+PXClass.h"
#import "objc.h"

static const int numberOfRetries = 1000;

@interface TestSuperProxy : XCTestCase

@end

@implementation TestSuperProxy


- (void)testProxyPerformance {

    UILabel *label = [UILabel new];

    [self measureBlock:^{
        for (int i = 0; i < numberOfRetries; ++i)
        {
            [label.stkSuper setText:@"text"];
        }
    }];
}

- (void)testCallSuperPerformance {

    UILabel *label = [UILabel new];

    [self measureBlock:^{
        for (int i = 0; i < numberOfRetries; ++i)
        {
            callSuper1(label, label.pxClass, @selector(setText:), @"text");
        }
    }];
}


@end
