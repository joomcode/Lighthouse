//
//  RTRContentFeedbackUpdateTask.m
//  Router
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRContentFeedbackUpdateTask.h"
#import "RTRTaskQueue.h"

@interface RTRContentFeedbackUpdateTask ()

@property (nonatomic, strong, readonly) id<RTRNode> sourceNode;
@property (nonatomic, copy, readonly) void (^nodeUpdateBlock)();

@property (nonatomic, copy) RTRTaskCompletionBlock sourceNodeContentUpdateCompletionBlock;
@property (nonatomic, assign) BOOL sourceNodeContentUpdateFinished;

@end


@implementation RTRContentFeedbackUpdateTask

#pragma mark - Init

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated {
    return [self initWithComponents:components animated:animated sourceNode:nil nodeUpdateBlock:nil];
}

- (instancetype)initWithComponents:(RTRComponents *)components
                          animated:(BOOL)animated
                        sourceNode:(id<RTRNode>)node
                   nodeUpdateBlock:(void (^)())block
{
    NSParameterAssert(node != nil);
    NSParameterAssert(block != nil);
    
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

- (void)updateContentForNode:(id<RTRNode>)node withUpdateQueue:(RTRTaskQueue *)updateQueue {
    if (node != self.sourceNode) {
        [super updateContentForNode:node withUpdateQueue:updateQueue];
        return;
    }
    
    [updateQueue runAsyncTaskWithBlock:^(RTRTaskCompletionBlock completion) {
        self.sourceNodeContentUpdateCompletionBlock = completion;
        
        if (self.sourceNodeContentUpdateFinished) {
            completion();
        }
    }];
}

#pragma mark - Source node content update

- (void)sourceNodeContentUpdateDidFinish {
    self.sourceNodeContentUpdateFinished = YES;
    
    if (self.sourceNodeContentUpdateCompletionBlock) {
        self.sourceNodeContentUpdateCompletionBlock();
    }    
}

@end
