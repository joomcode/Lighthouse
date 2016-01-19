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

NS_ASSUME_NONNULL_BEGIN


@protocol RTRDriver <NSObject>

@property (nonatomic, strong, readonly, nullable) id data;

- (void)updateWithContext:(id<RTRDriverUpdateContext>)context;


@optional

// TODO: make these required?.. optionals are cumbersome

@property (nonatomic, strong) id<RTRDriverFeedbackChannel> feedbackChannel;

- (void)stateDidChange:(RTRNodeState)state;

@end


NS_ASSUME_NONNULL_END