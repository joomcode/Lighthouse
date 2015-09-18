//
//  RTRNodeContentFeedbackChannelImpl.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentFeedbackChannel.h"

@interface RTRNodeContentFeedbackChannelImpl : NSObject <RTRNodeContentFeedbackChannel>

- (instancetype)initWithWillBecomeActiveBlock:(void (^)(id<RTRNode> node))willBlock
                         didBecomeActiveBlock:(void (^)(id<RTRNode> node))didBlock;

@end
