//
//  RTRNodeContentFeedbackChannelImpl.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentFeedbackChannelImpl.h"

@interface RTRNodeContentFeedbackChannelImpl ()

@property (nonatomic, copy) void (^willBlock)(NSSet *nodes);
@property (nonatomic, copy) void (^didBlock)(NSSet *nodes);

@end


@implementation RTRNodeContentFeedbackChannelImpl

#pragma mark - Init

- (instancetype)init {
    return [self initWithWillBecomeActiveBlock:nil didBecomeActiveBlock:nil];
}

- (instancetype)initWithWillBecomeActiveBlock:(void (^)(NSSet *nodes))willBlock
                         didBecomeActiveBlock:(void (^)(NSSet *nodes))didBlock
{
    NSParameterAssert(willBlock != nil);
    NSParameterAssert(didBlock != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _willBlock = [willBlock copy];
    _didBlock = [didBlock copy];
    
    return self;
}

#pragma mark - RTRNodeContentFeedbackChannel

- (void)childNodesWillBecomeActive:(NSSet *)nodes {
    self.willBlock(nodes);
}

- (void)childNodesDidBecomeActive:(NSSet *)nodes {
    self.didBlock(nodes);
}

@end
