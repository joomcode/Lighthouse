//
//  RTRNodeContent.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRCommand;
@protocol RTRNodeContentUpdateContext;
@protocol RTRNodeContentFeedbackChannel;

@protocol RTRNodeContent <NSObject>

@property (nonatomic, strong, readonly) id data;

- (void)setupDataWithCommand:(id<RTRCommand>)command;

- (void)performUpdateWithContext:(id<RTRNodeContentUpdateContext>)updateContext;


@optional

@property (nonatomic, strong) id<RTRNodeContentFeedbackChannel> feedbackChannel;

@end