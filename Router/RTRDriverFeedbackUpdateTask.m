//
//  RTRDriverFeedbackUpdateTask.m
//  Router
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRDriverFeedbackUpdateTask.h"
#import "RTRTaskQueue.h"

@interface RTRDriverFeedbackUpdateTask ()

@property (nonatomic, strong, readonly) id<RTRNode> sourceNode;
@property (nonatomic, copy, readonly) void (^nodeUpdateBlock)();

@property (nonatomic, copy) RTRTaskCompletionBlock sourceDriverUpdateCompletionBlock;
@property (nonatomic, assign) BOOL sourceDriverUpdateFinished;

@end


@implementation RTRDriverFeedbackUpdateTask

#pragma mark - Init

- (instancetype)initWithComponents:(RTRComponents *)components
                          animated:(BOOL)animated
                        sourceNode:(id<RTRNode>)node
                   nodeUpdateBlock:(void (^)())block
{
    self = [super initWithComponents:components animated:animated];
    if (!self) return nil;
    
    _sourceNode = node;
    _nodeUpdateBlock = [block copy];
    
    return self;
}

#pragma mark - RTRNodeUpdateTask

- (void)updateNodes {
    self.nodeUpdateBlock();
}

- (void)updateDriverForNode:(id<RTRNode>)node withUpdateQueue:(RTRTaskQueue *)updateQueue {
    if (node != self.sourceNode) {
        [super updateDriverForNode:node withUpdateQueue:updateQueue];
        return;
    }
    
    [updateQueue runAsyncTaskWithBlock:^(RTRTaskCompletionBlock completion) {
        self.sourceDriverUpdateCompletionBlock = completion;
        
        if (self.sourceDriverUpdateFinished) {
            completion();
        }
    }];
}

#pragma mark - Source node driver update

- (void)sourceDriverUpdateDidFinish {
    self.sourceDriverUpdateFinished = YES;
    
    if (self.sourceDriverUpdateCompletionBlock) {
        self.sourceDriverUpdateCompletionBlock();
    }    
}

@end
