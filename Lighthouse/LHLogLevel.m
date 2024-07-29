//
//  LHLogLevel.m
//  Lighthouse
//
//  Created by Artem Starosvetskiy on 7/14/17.
//  Copyright © 2017 Pixty. All rights reserved.
//

#import "LHLogLevel.h"

NS_ASSUME_NONNULL_BEGIN

static LHLogLevel LHCurrentAcceptedLogLevel = LHLogLevelInfo;

LHLogLevel LHAcceptedLogLevel(void) {
    NSCAssert(NSThread.currentThread.isMainThread, @"%s should be called from the main thread.", __PRETTY_FUNCTION__);

    return LHCurrentAcceptedLogLevel;
}

void LHSetAcceptedLogLevel(LHLogLevel logLevel) {
    NSCAssert(NSThread.currentThread.isMainThread, @"%s should be called from the main thread.", __PRETTY_FUNCTION__);

    LHCurrentAcceptedLogLevel = logLevel;
}

NS_ASSUME_NONNULL_END
