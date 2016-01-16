/****************************************************************************
 *
 * Copyright 2015-present StylingKit Development Team. All rights reserved.
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

//
// Created by Anton Matosov
//

#import <Foundation/Foundation.h>

@interface STKCloud : NSObject

/**
 *  Returns the server's URL.
 *
 *  @warning This property is only valid if the server is running.
 */
@property(nonatomic, readonly) NSURL* serverURL;

/**
 *  Returns the server's Bonjour URL.
 *
 *  @warning This property is only valid if the server is running and Bonjour
 *  registration has successfully completed, which can take up to a few seconds.
 *  Also be aware this property will not automatically update if the Bonjour hostname
 *  has been dynamically changed after the server started running (this should be rare).
 */
@property(nonatomic, readonly) NSURL* bonjourServerURL;

/**
 *  Returns the server's public URL.
 *
 *  @warning This property is only valid if the server is running and NAT port
 *  mapping is active.
 */
@property(nonatomic, readonly) NSURL* publicServerURL;

+ (instancetype)defaultCloud;

- (void)startLocalServer;

@end
