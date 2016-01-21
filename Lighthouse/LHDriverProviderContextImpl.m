//
//  LHDriverProviderContextImpl.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 21/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHDriverProviderContextImpl.h"

@implementation LHDriverProviderContextImpl

#pragma mark - Init

- (instancetype)initWithFeedbackChannel:(id<LHDriverFeedbackChannel>)feedbackChannel {
    self = [super init];
    if (!self) return nil;
    
    _feedbackChannel = feedbackChannel;
    
    return self;
}

#pragma mark - LHDriverProviderContext

@synthesize feedbackChannel = _feedbackChannel;

@end
