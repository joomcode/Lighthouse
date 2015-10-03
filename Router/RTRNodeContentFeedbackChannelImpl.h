//
//  RTRNodeContentFeedbackChannelImpl.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentFeedbackChannel.h"

@class RTRComponents;
@class RTRTaskQueue;

@interface RTRNodeContentFeedbackChannelImpl : NSObject <RTRNodeContentFeedbackChannel>

- (instancetype)initWithNode:(id<RTRNode>)node components:(RTRComponents *)components updateQueue:(RTRTaskQueue *)updateQueue;

@end
