//
//  LHRouterResumeTokenImpl.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHRouterResumeToken.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHRouterResumeTokenImpl : NSObject <LHRouterResumeToken>

- (instancetype)initWithResumeBlock:(void (^)(LHRouterResumeTokenImpl *token))block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END