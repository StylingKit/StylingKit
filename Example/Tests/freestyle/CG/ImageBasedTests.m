/****************************************************************************
 *
 * Copyright 2015-present StylingKit Development Team. All rights reserved.
 * Copyright 2013 Pixate, Inc. All rights reserved.
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

#import "ImageBasedTests.h"
#import "UIImage+Compare.h"

#define BYTES_PER_PIXEL 4
#define BITS_PER_CHANNEL 8

@interface ImageBasedTests ()
@end

@implementation ImageBasedTests

- (NSString *)rasterImageDirectoryName
{
    return @"Rendering";
}

- (void)assertImage:(UIImage *)image1 equalsImage:(UIImage *)image2
{
    XCTAssertTrue([image1 fb_compareWithImage:image2 tolerance:1.f], @"Images are not equal");
}

- (NSString *)localPathForName:(NSString *)name
{
    static NSString *tempDirectory;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tempDirectory = NSHomeDirectory();
    });

    return [NSString stringWithFormat:@"%@/%@.png", tempDirectory, name];
}

- (UIImage *)getImageForName:(NSString *)name
{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:name ofType:@"png"];

    return [UIImage imageWithContentsOfFile:path];
}

- (void)writeImage:(UIImage *)image withName:(NSString *)name overwrite:(BOOL)overwrite
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *outputPath = [self localPathForName:name];

    // only create file if it doesn't exist already
    if (overwrite || ![fileManager fileExistsAtPath:outputPath])
    {
        NSData *myImageData = UIImagePNGRepresentation(image);
        [fileManager createFileAtPath:outputPath contents:myImageData attributes:nil];
    }
}

- (void)writeImage:(UIImage *)image withPath:(NSString *)outputPath overwrite:(BOOL)overwrite
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // only create file if it doesn't exist already
    if (overwrite || ![fileManager fileExistsAtPath:outputPath])
    {
        NSData *myImageData = UIImagePNGRepresentation(image);
        [fileManager createFileAtPath:outputPath contents:myImageData attributes:nil];
    }
}


@end
