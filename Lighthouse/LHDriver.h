//
//  LHDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodeState.h"

@protocol LHCommand;
@protocol LHDriverUpdateContext;
@protocol LHDriverFeedbackChannel;

NS_ASSUME_NONNULL_BEGIN


@protocol LHDriver <NSObject>

@property (nonatomic, strong, readonly, nullable) id data;

- (void)updateWithContext:(id<LHDriverUpdateContext>)context;


@optional

// TODO: make these required?.. optionals are cumbersome

@property (nonatomic, strong) id<LHDriverFeedbackChannel> feedbackChannel;

- (void)stateDidChange:(LHNodeState)state;

@end


NS_ASSUME_NONNULL_END