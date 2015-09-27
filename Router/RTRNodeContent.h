//
//  RTRNodeContent.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTRNodeState.h"

@protocol RTRCommand;
@protocol RTRNodeContentUpdateContext;
@protocol RTRNodeContentDidUpdateContext;
@protocol RTRNodeContentFeedbackChannel;

@protocol RTRNodeContent <NSObject>

@property (nonatomic, strong, readonly) id data;

- (void)updateWithContext:(id<RTRNodeContentUpdateContext>)context;


@optional

@property (nonatomic, strong) id<RTRNodeContentFeedbackChannel> feedbackChannel;

- (void)stateDidChange:(RTRNodeState)state;

@end