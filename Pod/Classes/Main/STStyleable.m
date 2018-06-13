//
//  Test.m
//  StylingKit
//
//  Created by politom on 07/06/2018.
//  Copyright © 2018 CSE. All rights reserved.
//

#import "STStyleable.H"

@implementation STStyleable

@synthesize bounds;

@synthesize pxStyleChildren;

@synthesize pxStyleParent;

@synthesize styleChangeable;

@synthesize styleClass;

@synthesize styleClasses;

- (void)setStyleClass:(NSString *)aClass
{
    // make sure we have a string - needed to filter bad input from IB
    aClass = [aClass.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *classes = [aClass componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    styleClasses = [NSMutableSet setWithArray:classes];
}

@synthesize styleId;

@synthesize styleKey;

@synthesize styleMode;

@synthesize pxStyleElementName;

@synthesize frame;

@end
