/*
 * Copyright 2012-present Pixate, Inc.
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
//  PixateConfiguration.m
//  Pixate
//
//  Modified by Anton Matosov on 12/30/15.
//  Created by Kevin Lindsey on 1/23/13.
//  Copyright (c) 2013 Pixate, Inc. All rights reserved.
//

#import "PixateFreestyleConfiguration.h"
#import "PXCacheManager.h"
#import "PixateFreestyle.h"
#import "PXGenericStyler.h"
#import "PXDeclaration.h"
#import "PXStyleUtils.h"

@implementation PixateFreestyleConfiguration
{
    NSMutableDictionary *properties_;
    NSSet *_styleClasses;
}

@synthesize styleChangeable;

STK_DEFINE_CLASS_LOG_LEVEL

#pragma mark - Initializers

- (instancetype)init
{
    if (self = [super init])
    {
        // set default configuration settings here
        _parseErrorDestination = PXParseErrorDestinationNone;
        _cacheStylesType = PXCacheStylesTypeStyleOnce | PXCacheStylesTypeImages;

        _imageCacheCount = 10;
        _imageCacheSize = 0;
        _styleCacheCount = 10;

        _styleMode = PXStylingNormal;
    }

    return self;
}

#pragma mark - Methods

- (id)propertyValueForName:(NSString *)name
{
    return properties_[name];
}

- (void)setPropertyValue:(id)value forName:(NSString *)name
{
    if (value && name)
    {
        if (properties_ == nil)
        {
            properties_ = [[NSMutableDictionary alloc] init];
        }

        properties_[name] = value;
    }
}

- (void)sendParseMessage:(NSString *)message
{
    switch (_parseErrorDestination)
    {
        case PXParseErrorDestinationConsole:
            NSLog(@"%@", message);
            break;

#ifdef PX_LOGGING
        case PXParseErrorDestination_Logger:
            DDLogWarn(@"%@", message);
            break;
#endif

        case PXParseErrorDestinationNone:
            break;
    }
}

- (BOOL)cacheImages
{
    return (_cacheStylesType & PXCacheStylesTypeImages) == PXCacheStylesTypeImages;
}

- (BOOL)cacheStyles
{
    return (_cacheStylesType & PXCacheStylesTypeSave) == PXCacheStylesTypeSave;
}

- (BOOL)preventRedundantStyling
{
    return (_cacheStylesType & PXCacheStylesTypeStyleOnce) == PXCacheStylesTypeStyleOnce;
}

- (void)setImageCacheCount:(NSUInteger)imageCacheCount
{
    [PXCacheManager setImageCacheCount:imageCacheCount];
}

- (void)setImageCacheSize:(NSUInteger)imageCacheSize
{
    [PXCacheManager setImageCacheSize:imageCacheSize];
}

- (void)setStyleCacheCount:(NSUInteger)styleCacheCount
{
    [PXCacheManager setStyleCacheCount:styleCacheCount];
}

#pragma mark - PXStyleable

- (void)setStyleId:(NSString *)anId
{
    // trim leading and trailing whitespace
    _styleId = [anId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)setStyleClass:(NSString *)aClass
{
    // trim leading and trailing whitespace
    _styleClass = [aClass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *classes = [_styleClass componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    _styleClasses = [NSSet setWithArray:classes];
}

- (NSSet *)styleClasses {
    return _styleClasses;
}

- (NSString *)pxStyleElementName
{
    return @"stylingkit-config";
}

- (id)pxStyleParent
{
    return nil;
}

- (NSArray *)pxStyleChildren
{
    return nil;
}

- (CGRect)bounds
{
    return CGRectZero;
}

- (CGRect)frame
{
    return CGRectZero;
}

- (NSString *)styleKey
{
    return [PXStyleUtils styleKeyFromStyleable:self];
}

- (void)setBounds:(CGRect)bounds
{
    // ignore
}

- (void)setFrame:(CGRect)frame
{
    // ignore
}

- (NSArray *)viewStylers
{
    static __strong NSArray *stylers = nil;
	static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        stylers = @[
            [[PXGenericStyler alloc] initWithHandlers: @{
                @"parse-error-destination" : ^(PXDeclaration *declaration, PXStylerContext *context) {
                    PixateFreestyle.configuration.parseErrorDestination = declaration.parseErrorDestinationValue;
                },
                @"cache-styles" : ^(PXDeclaration *declaration, PXStylerContext *context) {
                    PixateFreestyle.configuration.cacheStylesType = declaration.cacheStylesTypeValue;

                    // clear caches if they are off
                    if (!PixateFreestyle.configuration.cacheImages)
                    {
                        [PixateFreestyle clearImageCache];
                    }
                    if (!PixateFreestyle.configuration.cacheStyles)
                    {
                        [PixateFreestyle clearStyleCache];
                    }
                },
                @"image-cache-count" : ^(PXDeclaration *declaration, PXStylerContext *context) {
                    NSString *value = declaration.stringValue;

                    PixateFreestyle.configuration.imageCacheCount = value.integerValue;
                },
                @"image-cache-size" : ^(PXDeclaration *declaration, PXStylerContext *context) {
                    NSString *value = declaration.stringValue;

                    PixateFreestyle.configuration.imageCacheSize = value.integerValue;
                },
                @"style-cache-count" : ^(PXDeclaration *declaration, PXStylerContext *context) {
                    NSString *value = declaration.stringValue;

                    PixateFreestyle.configuration.styleCacheCount = value.integerValue;
                },
              @"enabled" : ^(PXDeclaration* declaration, PXStylerContext* context) {
                  BOOL value = declaration.booleanValue;

                  PixateFreestyle.configuration.styleMode = value ? PXStylingNormal : PXStylingNone;
              }
            }]
        ];
    });

	return stylers;
}

- (NSDictionary *)viewStylersByProperty
{
    static NSDictionary *map = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        map = [PXStyleUtils viewStylerPropertyMapForStyleable:self];
    });

    return map;
}

@end
