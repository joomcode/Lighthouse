//
//  RTRDriverFeedbackChannelImpl.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriverFeedbackChannel.h"

@class RTRComponents;
@class RTRTaskQueue;

NS_ASSUME_NONNULL_BEGIN


@interface RTRDriverFeedbackChannelImpl : NSObject <RTRDriverFeedbackChannel>

- (instancetype)initWithNode:(id<RTRNode>)node
                  components:(RTRComponents *)components
                 updateQueue:(RTRTaskQueue *)updateQueue NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END