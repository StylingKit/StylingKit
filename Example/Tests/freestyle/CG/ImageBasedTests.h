/****************************************************************************
 *
 * Copyright 2015-present StylingKit Development Team
 * Copyright 2013 Pixate, Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 ****************************************************************************/

//  Modified by Anton Matosov on 12/30/15.

#import <XCTest/XCTest.h>

@interface ImageBasedTests : XCTestCase

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *rasterImageDirectoryName;

- (void)assertImage:(UIImage *)image1 equalsImage:(UIImage *)image2;
- (NSString *)localPathForName:(NSString *)name;
- (void)writeImage:(UIImage *)image withName:(NSString *)name overwrite:(BOOL)overwrite;
- (void)writeImage:(UIImage *)image withPath:(NSString *)outputPath overwrite:(BOOL)overwrite;
- (UIImage *)getImageForName:(NSString *)name;

@end
