//
//  LHLogger.m
//  Lighthouse
//
//  Created by Artem Starosvetskiy on 7/14/17.
//  Copyright © 2017 Pixty. All rights reserved.
//

#import "LHLogger.h"

NS_ASSUME_NONNULL_BEGIN

static id<LHLogger> LHCurrentSharedLogger;

id<LHLogger> LHSharedLogger() {
    NSCAssert(NSThread.currentThread.isMainThread, @"%s should be called from the main thread.", __PRETTY_FUNCTION__);
    
    if (!LHCurrentSharedLogger) {
        LHCurrentSharedLogger = [[LHNSLogLogger alloc] init];
    }
    return LHCurrentSharedLogger;
}

__used void LHSetSharedLogger(id<LHLogger> logger) {
    NSCParameterAssert(logger);
    NSCAssert(NSThread.currentThread.isMainThread, @"%s should be called from the main thread.", __PRETTY_FUNCTION__);
    
    LHCurrentSharedLogger = logger;
}

@implementation LHNSLogLogger

#pragma mark - LHLogger

- (void)logMessageWithLevel:(LHLogLevel)logLevel format:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    
    NSString *logLevelName = @"Unknown";
    switch(logLevel) {
        case LHLogLevelError:
            logLevelName = @"Error";
            break;
        case LHLogLevelWarning:
            logLevelName = @"Warning";
            break;
        case LHLogLevelInfo:
            logLevelName = @"Info";
            break;
        case LHLogLevelDebug:
            logLevelName = @"Debug";
            break;
    };

    format = [NSString stringWithFormat:@"[%@] %@", logLevelName, format];
    NSLogv(format, args);
    
    va_end(args);
}

@end

NS_ASSUME_NONNULL_END
