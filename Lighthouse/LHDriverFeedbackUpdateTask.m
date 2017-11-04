//
//  LHDriverFeedbackUpdateTask.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHDriverFeedbackUpdateTask.h"
#import "LHTaskQueue.h"

@interface LHDriverFeedbackUpdateTask ()

@property (nonatomic, strong, readonly) id<LHNode> sourceNode;
@property (nonatomic, copy, readonly) void (^nodeUpdateBlock)(void);

@property (nonatomic, copy) LHTaskCompletionBlock sourceDriverUpdateCompletionBlock;
@property (nonatomic, assign) BOOL sourceDriverUpdateFinished;

@end


@implementation LHDriverFeedbackUpdateTask

#pragma mark - Init

- (instancetype)initWithComponents:(LHComponents *)components
                          animated:(BOOL)animated
                        sourceNode:(id<LHNode>)node
                   nodeUpdateBlock:(void (^)(void))block
{
    self = [super initWithComponents:components animated:animated];
    if (!self) return nil;
    
    _sourceNode = node;
    _nodeUpdateBlock = [block copy];
    
    return self;
}

#pragma mark - LHNodeUpdateTask

- (void)updateNodesWithCompletion:(LHTaskCompletionBlock)completion {
    self.nodeUpdateBlock();
    completion();
}

- (void)updateDriverForNode:(id<LHNode>)node withUpdateQueue:(id<LHTaskQueue>)updateQueue {
    if (node != self.sourceNode) {
        [super updateDriverForNode:node withUpdateQueue:updateQueue];
        return;
    }
    
    [updateQueue runAsyncTaskWithBlock:^(LHTaskCompletionBlock completion) {
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
