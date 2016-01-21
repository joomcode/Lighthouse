//
//  LHContainerDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 21/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHDriver.h"

@protocol LHDriverFeedbackChannel;

NS_ASSUME_NONNULL_BEGIN


@interface LHContainerDriver : NSObject <LHDriver>

@property (nonatomic, strong, readonly) id<LHDriverFeedbackChannel> feedbackChannel;

// TODO: @property with recent nodeChildrenState

- (instancetype)initWithFeedbackChannel:(id<LHDriverFeedbackChannel>)feedbackChannel;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END