//
//  RTRNodeContentFeedbackChannelImpl.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentFeedbackChannelImpl.h"

@implementation RTRNodeContentFeedbackChannelImpl

- (void)childNodeDidBecomeActive:(id<RTRNode>)node {
    self.childActivatedBlock(node);
}

@end
