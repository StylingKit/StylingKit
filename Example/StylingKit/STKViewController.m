/*
 * Copyright 2015-present StylingKit Development Team. All rights reserved..
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
//  Created by Anton Matosov on 12/08/2015.
//

#import "STKViewController.h"

@interface STKViewController ()

@end

@implementation STKViewController

- (IBAction)showAlertView
{

//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Title"
//                                                        message:@"Message"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Cancel"
//                                              otherButtonTitles:@"OK", nil];
//
//    [alertView show];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Title"
                                                                             message:@"Message"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"folder name";
        textField.keyboardType = UIKeyboardTypeASCIICapable;
    }];

    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}

@end
