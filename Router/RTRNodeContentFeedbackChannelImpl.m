//
//  RTRNodeContentFeedbackChannelImpl.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentFeedbackChannelImpl.h"

@interface RTRNodeContentFeedbackChannelImpl ()

@property (nonatomic, copy) void (^willBlock)(id<RTRNode> node);
@property (nonatomic, copy) void (^didBlock)(id<RTRNode> node);

@end


@implementation RTRNodeContentFeedbackChannelImpl

#pragma mark - Init

- (instancetype)init {
    return [self initWithWillBecomeActiveBlock:nil didBecomeActiveBlock:nil];
}

- (instancetype)initWithWillBecomeActiveBlock:(void (^)(id<RTRNode> node))willBlock
                         didBecomeActiveBlock:(void (^)(id<RTRNode> node))didBlock
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

- (void)childNodeWillBecomeActive:(id<RTRNode>)node {
    self.willBlock(node);
}

- (void)childNodeDidBecomeActive:(id<RTRNode>)node {
    self.didBlock(node);
}

@end
