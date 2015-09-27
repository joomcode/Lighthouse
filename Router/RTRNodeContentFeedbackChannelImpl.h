//
//  RTRNodeContentFeedbackChannelImpl.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentFeedbackChannel.h"
#import "RTRNodeUpdate.h"

@interface RTRNodeContentFeedbackChannelImpl : NSObject <RTRNodeContentFeedbackChannel>

- (instancetype)initWithNodeUpdateProviderBlock:(id<RTRNodeUpdate> (^)(RTRNodeUpdateBlock updateBlock))block;

@end
