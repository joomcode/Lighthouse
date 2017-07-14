//
//  LHLogger.h
//  Lighthouse
//
//  Created by Artem Starosvetskiy on 7/14/17.
//  Copyright © 2017 Pixty. All rights reserved.
//

#import "LHLogLevel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LHLogger <NSObject>

- (void)logMessageWithLevel:(LHLogLevel)logLevel format:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);

@end

/// The class provides a logger which just calls `NSLog`.
@interface LHNSLogLogger : NSObject <LHLogger>

@end

/// Returns a shared logger.
///
/// Defaults to an instance of `LHNSLogLogger`.
///
/// @note Should be called from the main thread.
extern id<LHLogger> LHSharedLogger();

/// Sets a shared logger.
///
/// @note Should be called from the main thread.
extern void LHSetSharedLogger(id<LHLogger> logger);

#define LHLog(logLevel_, format_, ...) \
    do { \
        if ((logLevel_) <= LHAcceptedLogLevel()) [LHSharedLogger() logMessageWithLevel:(logLevel_) format:(format_), ##__VA_ARGS__]; \
    } while (NO)

#define LHLogError(format_, ...) LHLog(LHLogLevelError, (format_), ##__VA_ARGS__)
#define LHLogWarning(format_, ...) LHLog(LHLogLevelWarning, (format_), ##__VA_ARGS__)
#define LHLogInfo(format_, ...) LHLog(LHLogLevelInfo, (format_), ##__VA_ARGS__)
#define LHLogDebug(format_, ...) LHLog(LHLogLevelDebug, (format_), ##__VA_ARGS__)

NS_ASSUME_NONNULL_END
