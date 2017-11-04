//
//  LHLogLevel.h
//  Lighthouse
//
//  Created by Artem Starosvetskiy on 7/14/17.
//  Copyright © 2017 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LHLogLevel) {
    LHLogLevelError,
    LHLogLevelWarning,
    LHLogLevelInfo,
    LHLogLevelDebug,
};

/// Returns the maximum accepted log level.
///
/// @note Should be called from the main thread.
extern LHLogLevel LHAcceptedLogLevel(void);

/// Sets the maximum accepted log level.
///
/// @note Should be called from the main thread.
extern void LHSetAcceptedLogLevel(LHLogLevel logLevel);

NS_ASSUME_NONNULL_END
