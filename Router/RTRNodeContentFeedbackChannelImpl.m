//
//  RTRNodeContentFeedbackChannelImpl.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentFeedbackChannelImpl.h"
#import "RTRComponents.h"
#import "RTRTaskQueue.h"
#import "RTRContentFeedbackUpdateTask.h"

@interface RTRNodeContentFeedbackChannelImpl ()

@property (nonatomic, strong, readonly) id<RTRNode> node;
@property (nonatomic, strong, readonly) RTRComponents *components;
@property (nonatomic, strong, readonly) RTRTaskQueue *updateQueue;

@property (nonatomic, strong) RTRContentFeedbackUpdateTask *currentTask;

@end


@implementation RTRNodeContentFeedbackChannelImpl

#pragma mark - Init

- (instancetype)init {
    return [self initWithNode:nil components:nil updateQueue:nil];
}

- (instancetype)initWithNode:(id<RTRNode>)node components:(RTRComponents *)components updateQueue:(RTRTaskQueue *)updateQueue {
    NSParameterAssert(node != nil);
    NSParameterAssert(components != nil);
    NSParameterAssert(updateQueue != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _node = node;
    _components = components;
    _updateQueue = updateQueue;
    
    return self;
}

#pragma mark - RTRNodeContentFeedback

- (void)startNodeUpdateWithBlock:(void (^)(id<RTRNode> node))updateBlock {
    NSParameterAssert(updateBlock != nil);

    if (self.currentTask) {
        [self finishNodeUpdate];
    }
    
    self.currentTask = [[RTRContentFeedbackUpdateTask alloc] initWithComponents:self.components
                                                                       animated:YES
                                                                     sourceNode:self.node
                                                                nodeUpdateBlock:^{
                                                                    updateBlock(self.node);
                                                                }];
    
    [self.updateQueue runTask:self.currentTask];
}

- (void)finishNodeUpdate {
    [self.currentTask sourceNodeContentUpdateDidFinish];
    
    self.currentTask = nil;
}

@end
