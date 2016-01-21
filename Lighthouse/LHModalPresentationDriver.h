//
//  LHModalPresentationDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHContainerDriver.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface LHModalPresentationDriver : LHContainerDriver

@property (nonatomic, strong, readonly) UIWindow *data;

- (instancetype)initWithWindow:(UIWindow *)window
               feedbackChannel:(id<LHDriverFeedbackChannel>)feedbackChannel NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithFeedbackChannel:(id<LHDriverFeedbackChannel>)feedbackChannel NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END