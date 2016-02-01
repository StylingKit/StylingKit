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
//  PXLog.h
//  Pixate
//
//  Modified by Anton Matosov on 1/4/16.
//  Created by Paul Colton on 12/8/12.
//  Copyright (c) 2012 Pixate, Inc. All rights reserved.
//


#if defined(STK_LOGGING) && defined(__has_include) && (__has_include("CocoaLumberjack.h") || __has_include("CocoaLumberjack/CocoaLumberjack.h"))

#define PX_LOGGING STK_LOGGING

# import <CocoaLumberjack/CocoaLumberjack.h>

static const DDLogLevel LogLevelDefault = DDLogLevelWarning;

# define PX_DEFINE_FILE_LOG_LEVEL static const DDLogLevel ddLogLevel = LogLevelDefault;

# define STK_DEFINE_CLASS_LOG_LEVEL                 \
  static DDLogLevel ddLogLevel = LogLevelDefault;   \
  + (DDLogLevel)ddLogLevel                          \
  {                                                 \
    return ddLogLevel;                              \
  }                                                 \
                                                    \
  + (void)ddSetLogLevel:(DDLogLevel)logLevel        \
  {                                                 \
    ddLogLevel = logLevel;                          \
  }


#else

# define STK_DEFINE_CLASS_LOG_LEVEL
# define PX_DEFINE_FILE_LOG_LEVEL

# define DDLogError(...)
# define DDLogWarn(...)
# define DDLogInfo(...)
# define DDLogVerbose(...)
# define DDLogDebug(...)

typedef enum{DDLogLevelNone} DDLogLevel;

#endif
