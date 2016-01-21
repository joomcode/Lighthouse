//
//  LHContainerDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 21/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHContainerDriver.h"

@implementation LHContainerDriver

#pragma mark - Init

- (instancetype)initWithFeedbackChannel:(id<LHDriverFeedbackChannel>)feedbackChannel {
    self = [super init];
    if (!self) return nil;
    
    _feedbackChannel = feedbackChannel;
    
    return self;
}

#pragma mark - LHDriver

@dynamic data;

- (void)updateWithContext:(id<LHDriverUpdateContext>)context {
}

- (void)presentationStateDidChange:(LHNodePresentationState)presentationState {
}

@end
