//
//  RTRDriverFeedbackChannelImpl.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriverFeedbackChannelImpl.h"
#import "RTRComponents.h"
#import "RTRTaskQueue.h"
#import "RTRDriverFeedbackUpdateTask.h"

@interface RTRDriverFeedbackChannelImpl ()

@property (nonatomic, strong, readonly) id<RTRNode> node;
@property (nonatomic, strong, readonly) RTRComponents *components;
@property (nonatomic, strong, readonly) RTRTaskQueue *updateQueue;

@property (nonatomic, strong) RTRDriverFeedbackUpdateTask *currentTask;

@end


@implementation RTRDriverFeedbackChannelImpl

#pragma mark - Init

- (instancetype)initWithNode:(id<RTRNode>)node components:(RTRComponents *)components updateQueue:(RTRTaskQueue *)updateQueue {
    self = [super init];
    if (!self) return nil;
    
    _node = node;
    _components = components;
    _updateQueue = updateQueue;
    
    return self;
}

#pragma mark - RTRDriverFeedback

- (void)startNodeUpdateWithBlock:(void (^)(id<RTRNode> node))updateBlock {
    NSParameterAssert(updateBlock != nil);

    if (self.currentTask) {
        [self.currentTask cancel];
        [self finishNodeUpdate];
    }
    
    self.currentTask = [[RTRDriverFeedbackUpdateTask alloc] initWithComponents:self.components
                                                                      animated:YES
                                                                    sourceNode:self.node
                                                               nodeUpdateBlock:^{
                                                                   updateBlock(self.node);
                                                               }];
    
    [self.updateQueue runTask:self.currentTask];
}

- (void)finishNodeUpdate {
    [self.currentTask sourceDriverUpdateDidFinish];
    
    self.currentTask = nil;
}

@end
