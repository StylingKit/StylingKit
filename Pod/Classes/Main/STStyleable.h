//
//  Test.h
//  StylingKit
//
//  Created by politom on 07/06/2018.
//  Copyright © 2018 CSE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXStyleable.h"
#import "UIView+PXStyling.h"

@interface STStyleable : NSObject  <PXStyleable>

@property(strong, nonatomic) UIFont* font;
@property(strong, nonatomic) UIColor* color;
@property(strong, nonatomic) UIColor* backgroundColor;

@end
