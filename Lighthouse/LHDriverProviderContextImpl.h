//
//  LHDriverProviderContextImpl.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 21/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHDriverProviderContext.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHDriverProviderContextImpl : NSObject <LHDriverProviderContext>

- (instancetype)initWithFeedbackChannel:(id<LHDriverFeedbackChannel>)feedbackChannel NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END