//
// Created by Anton Matosov on 10/12/15.
// Copyright (c) 2015 Pixate, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PXFontRegistry.h"

@interface PXFontRegistryTests : XCTestCase

@end

@implementation PXFontRegistryTests

- (void)testSystemFont
{
    UIFont *result = [PXFontRegistry fontWithFamily:@"SystemFont"
                                        fontStretch:@""
                                         fontWeight:@""
                                          fontStyle:@""
                                               size:10.f];
}

@end
