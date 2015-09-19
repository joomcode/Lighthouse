//
//  RTRNodeContentFeedbackChannelImpl.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentFeedbackChannel.h"

@interface RTRNodeContentFeedbackChannelImpl : NSObject <RTRNodeContentFeedbackChannel>

- (instancetype)initWithWillBecomeActiveBlock:(void (^)(NSSet *nodes))willBlock
                         didBecomeActiveBlock:(void (^)(NSSet *nodes))didBlock;

@end
