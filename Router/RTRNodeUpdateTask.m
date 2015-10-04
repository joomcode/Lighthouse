//
//  RTRNodeUpdateTask.m
//  Router
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRNodeUpdateTask.h"
#import "RTRComponents.h"
#import "RTRNodeDataStorage.h"
#import "RTRNodeData.h"
#import "RTRGraph.h"
#import "RTRNodeContentProvider.h"
#import "RTRNodeContent.h"
#import "RTRTaskQueue.h"
#import "RTRNode.h"
#import "RTRNodeChildrenState.h"
#import "RTRNodeTree.h"
#import "RTRNodeContentUpdateContextImpl.h"
#import "RTRNodeContentFeedbackChannelImpl.h"


@interface RTRNodeUpdateTask ()

@property (nonatomic, strong, readonly) RTRTaskQueue *contentUpdateQueue;

@property (nonatomic, strong, readonly) RTRNodeTree *affectedNodes;

@property (nonatomic, strong) NSSet *nodesForAnimatedContentUpdate;

@property (nonatomic, assign, getter = isCancelled) BOOL cancelled;

@end


@implementation RTRNodeUpdateTask

#pragma mark - Init

- (instancetype)init {
    return [self initWithComponents:nil animated:NO];
}

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated {
    NSParameterAssert(components != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _components = components;
    _animated = animated;
    
    _contentUpdateQueue = [[RTRTaskQueue alloc] init];
    
    _affectedNodes = [[RTRNodeTree alloc] init];
    [_affectedNodes addItem:_components.graph.rootNode afterItemOrNil:nil];
    
    return self;
}

#pragma mark - RTRTask

- (void)startWithCompletionBlock:(RTRTaskCompletionBlock)completionBlock {
    if (self.animated) {
        self.nodesForAnimatedContentUpdate = [[self.components.graph activeNodesTree] allItems];
    }
    
    [self markAffectedNodes];
    [self updateNodes];
    [self markAffectedNodes];
    
    [self updateAffectedNodesState];
    
    [self updateNodesContent];
    
    [self.contentUpdateQueue runTaskWithBlock:^{
        if (!self.cancelled) {
            [self cleanupAffectedNodes];
        }
        
        completionBlock();
    }];
}

#pragma mark - Cancellation

- (void)cancel {
    self.cancelled = YES;
    
    // TODO: do anything else here?
    // e.g. is there a way to cancel ongoing node content update?
}

#pragma mark - Subclassing

- (id<RTRCommand>)command {
    return nil;
}

- (void)updateNodes {
}

- (void)updateContentForNode:(id<RTRNode>)node withUpdateQueue:(RTRTaskQueue *)updateQueue {
    id<RTRNodeContent> nodeContent = [self.components.nodeDataStorage dataForNode:node].content;
    
    id<RTRNodeContentUpdateContext> updateContext =
        [[RTRNodeContentUpdateContextImpl alloc] initWithAnimated:[self.nodesForAnimatedContentUpdate containsObject:node]
                                                          command:[self command]
                                                      updateQueue:updateQueue
                                                    childrenState:node.childrenState
                                                     contentBlock:^id<RTRNodeContent>(id<RTRNode> node) {
                                                         return [self.components.nodeDataStorage dataForNode:node].content;
                                                     }];
    
    [nodeContent updateWithContext:updateContext];
}

#pragma mark - Node state manipulation

- (void)markAffectedNodes {
    RTRNodeTree *tree = [self.components.graph initializedNodesTree];
    
    [tree enumerateItemsWithBlock:^(id<RTRNode> node, id<RTRNode> previousNode, BOOL *stop) {
        [self.affectedNodes addItem:node afterItemOrNil:previousNode];
    }];
}

- (void)updateAffectedNodesState {
    [self.affectedNodes enumerateItemsWithBlock:^(id<RTRNode> node, id<RTRNode> previousNode, BOOL *stop) {
        if (!previousNode) {
            RTRNodeData *data = [self.components.nodeDataStorage dataForNode:node];
            data.state = RTRNodeStateActive;
            data.presentationState = RTRNodeStateActive;
        }
        
        for (id<RTRNode> childNode in [self.affectedNodes nextItems:node]) {
            RTRNodeState childState;
            
            if ([node.childrenState.activeChildren containsObject:childNode]) {
                childState = RTRNodeStateActive;
            } else if ([node.childrenState.initializedChildren containsObject:childNode]) {
                childState = RTRNodeStateInactive;
            } else {
                childState = RTRNodeStateNotInitialized;
            }
            
            [self.components.nodeDataStorage dataForNode:childNode].state = childState;
        }
    }];
}

- (void)cleanupAffectedNodes {
    [self.affectedNodes enumerateItemsWithBlock:^(id<RTRNode> node, id<RTRNode> previousNode, BOOL *stop) {
        if (previousNode && ![previousNode.childrenState.initializedChildren containsObject:node]) {
            [self.components.nodeDataStorage resetDataForNode:node];
        }
    }];
}

#pragma mark - Node content manipulation

- (void)updateNodesContent {
    [self updateNodeContentRecursively:self.components.graph.rootNode];
}

- (void)updateNodeContentRecursively:(id<RTRNode>)node {
    for (id<RTRNode> childNode in [self.affectedNodes nextItems:node]) {
        [self updateNodeContentRecursively:childNode];
    }
        
    [self updateNodeContent:node];
}

- (void)updateNodeContent:(id<RTRNode>)node {
    RTRNodeData *data = [self.components.nodeDataStorage dataForNode:node];
    RTRTaskQueue *localUpdateQueue = [[RTRTaskQueue alloc] init];
    
    NSAssert(data.content != nil, @""); // TODO
    
    [self.contentUpdateQueue runTaskWithBlock:^{
        [self willUpdateNodeContent:node];
    }];
    
    [self.contentUpdateQueue runAsyncTaskWithBlock:^(RTRTaskCompletionBlock completion) {
        [self updateContentForNode:node withUpdateQueue:localUpdateQueue];
        
        [localUpdateQueue runTaskWithBlock:^{
            completion();
        }];
    }];
    
    [self.contentUpdateQueue runTaskWithBlock:^{
        [self didUpdateNodeContent:node];
    }];
}

- (void)willUpdateNodeContent:(id<RTRNode>)node {
    for (id<RTRNode> child in [node allChildren]) {
        RTRNodeData *childData = [self.components.nodeDataStorage dataForNode:child];
        
        RTRNodeState oldState = childData.presentationState;
        RTRNodeState newState = childData.state;
        
        if (oldState == RTRNodeStateNotInitialized && newState == RTRNodeStateInactive) {
            childData.presentationState = RTRNodeStateInactive;
        } else if ((oldState == RTRNodeStateInactive || oldState == RTRNodeStateNotInitialized) && newState == RTRNodeStateActive) {
            childData.presentationState = RTRNodeStateActivating;
        } else if (oldState == RTRNodeStateActive && (newState == RTRNodeStateInactive || newState == RTRNodeStateNotInitialized)) {
            childData.presentationState = RTRNodeStateDeactivating;
        }
    }
    
    [self.components.nodeDataStorage updateResolvedStateForAffectedNodeTree:self.affectedNodes];
}

- (void)didUpdateNodeContent:(id<RTRNode>)node {
    for (id<RTRNode> child in [node allChildren]) {
        RTRNodeData *childData = [self.components.nodeDataStorage dataForNode:child];
        childData.presentationState = childData.state;
    }
    
    [self.components.nodeDataStorage updateResolvedStateForAffectedNodeTree:self.affectedNodes];
}

@end
