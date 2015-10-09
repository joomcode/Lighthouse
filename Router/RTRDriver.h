//
//  RTRDriver.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTRNodeState.h"

@protocol RTRCommand;
@protocol RTRDriverUpdateContext;
@protocol RTRDriverFeedbackChannel;

@protocol RTRDriver <NSObject>

@property (nonatomic, strong, readonly) id data;

- (void)updateWithContext:(id<RTRDriverUpdateContext>)context;


@optional

@property (nonatomic, strong) id<RTRDriverFeedbackChannel> feedbackChannel;

- (void)stateDidChange:(RTRNodeState)state;

@end