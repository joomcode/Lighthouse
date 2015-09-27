//
//  RTRNodeUpdateTask.m
//  Router
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRNodeUpdateTask.h"
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

@end


@implementation RTRNodeUpdateTask

#pragma mark - Init

- (instancetype)init {
    return [self initWithNodeDataStorage:nil nodeContentProvider:nil graph:nil animated:NO];
}

- (instancetype)initWithNodeDataStorage:(RTRNodeDataStorage *)nodeDataStorage
                    nodeContentProvider:(id<RTRNodeContentProvider>)nodeContentProvider
                                  graph:(RTRGraph *)graph
                               animated:(BOOL)animated
{
    NSParameterAssert(nodeDataStorage != nil);
    NSParameterAssert(nodeContentProvider != nil);
    NSParameterAssert(graph != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _nodeDataStorage = nodeDataStorage;
    _nodeContentProvider = nodeContentProvider;
    _graph = graph;
    _animated = animated;
    
    _contentUpdateQueue = [[RTRTaskQueue alloc] init];
    
    _affectedNodes = [[RTRNodeTree alloc] init];
    [_affectedNodes addItem:_graph.rootNode afterItemOrNil:nil];
    
    return self;
}

#pragma mark - RTRTask

- (void)startWithCompletionBlock:(RTRTaskCompletionBlock)completionBlock {
    if (self.animated) {
        self.nodesForAnimatedContentUpdate = [[self.graph activeNodesTree] allItems];
    }
    
    [self markAffectedNodes];
    [self updateNodes];
    [self markAffectedNodes];
    
    [self updateAffectedNodesState];
    
    [self updateNodeContent];
    
    [self.contentUpdateQueue runTaskWithBlock:^{
        [self cleanupAffectedNodes];
        
        completionBlock();
    }];
}

#pragma mark - Abstract

- (id<RTRCommand>)command {
    return nil;
}

- (void)updateNodes {
}

- (BOOL)shouldUpdateContentForNode:(id<RTRNode>)node {
    return NO;
}

#pragma mark - Node state manipulation

- (NSMapTable *)takeNodeResolvedStateSnapshot {
    NSMapTable *stateByNodes = [NSMapTable strongToStrongObjectsMapTable];
    
    RTRNodeTree *tree = [self.graph initializedNodesTree];
    
    [tree enumerateItemsWithBlock:^(id<RTRNode> node, id<RTRNode> previousNode, BOOL *stop) {
        [stateByNodes setObject:@([self.nodeDataStorage resolvedStateForNode:node]) forKey:node];
    }];
    
    return stateByNodes;
}

- (void)markAffectedNodes {
    RTRNodeTree *tree = [self.graph initializedNodesTree];
    
    [tree enumerateItemsWithBlock:^(id<RTRNode> node, id<RTRNode> previousNode, BOOL *stop) {
        [self.affectedNodes addItem:node afterItemOrNil:previousNode];
    }];
}

- (void)updateAffectedNodesState {
    [self.affectedNodes enumerateItemsWithBlock:^(id<RTRNode> node, id<RTRNode> previousNode, BOOL *stop) {
        if (!previousNode) {
            RTRNodeData *data = [self.nodeDataStorage dataForNode:node];
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
            
            [self.nodeDataStorage dataForNode:childNode].state = childState;
        }
    }];
}

- (void)cleanupAffectedNodes {
    [self.affectedNodes enumerateItemsWithBlock:^(id<RTRNode> node, id<RTRNode> previousNode, BOOL *stop) {
        if (previousNode && ![previousNode.childrenState.initializedChildren containsObject:node]) {
            [self.nodeDataStorage resetDataForNode:node];
        }
    }];
}

#pragma mark - Node content manipulation

- (void)updateNodeContent {
    [self updateNodeContentRecursively:self.graph.rootNode];
}

- (void)updateNodeContentRecursively:(id<RTRNode>)node {
    for (id<RTRNode> childNode in [self.affectedNodes nextItems:node]) {
        [self updateNodeContentRecursively:childNode];
    }
    
    if ([self shouldUpdateContentForNode:node]) {
        [self updateNodeContent:node];
    }
}

- (void)updateNodeContent:(id<RTRNode>)node {
    RTRNodeData *data = [self.nodeDataStorage dataForNode:node];
    RTRTaskQueue *localUpdateQueue = [[RTRTaskQueue alloc] init];
    
    if (!data.content) {
        data.content = [self createContentForNode:node];
    }
    
    [self.contentUpdateQueue runTaskWithBlock:^{
        [self willUpdateNodeContent:node];
    }];
    
    [self.contentUpdateQueue runAsyncTaskWithBlock:^(RTRTaskCompletionBlock completion) {
        id<RTRNodeContentUpdateContext> updateContext =
            [[RTRNodeContentUpdateContextImpl alloc] initWithAnimated:[self.nodesForAnimatedContentUpdate containsObject:node]
                                                              command:[self command]
                                                          updateQueue:localUpdateQueue
                                                        childrenState:node.childrenState
                                                         contentBlock:^id<RTRNodeContent>(id<RTRNode> node) {
                                                             return [self.nodeDataStorage dataForNode:node].content;
                                                         }];
        
        [data.content updateWithContext:updateContext];
  
        [localUpdateQueue runTaskWithBlock:^{
            completion();
        }];
    }];
    
    [self.contentUpdateQueue runTaskWithBlock:^{
        [self didUpdateNodeContent:node];
    }];
}

- (id<RTRNodeContent>)createContentForNode:(id<RTRNode>)node {
    id<RTRNodeContent> content = [self.nodeContentProvider contentForNode:node];
    
    if (!content) {
        return nil;
    }
    
    if ([content respondsToSelector:@selector(setFeedbackChannel:)]) {
        __weak __typeof(self) weakSelf = self;

        // TODO
        
//        id<RTRNodeContentFeedbackChannel> feedbackChannel =
//            [[RTRNodeContentFeedbackChannelImpl alloc] initWithWillBecomeActiveBlock:^(NSSet *children) {
//                [weakSelf activateChildren:children ofParentNode:node];
//                [weakSelf willUpdateNodeContent:node];
//            } didBecomeActiveBlock:^(NSSet *children) {
//                [weakSelf didUpdateNodeContent:node];
//            }];
//        
//        content.feedbackChannel = feedbackChannel;
    }
    
    return content;
}

- (void)willUpdateNodeContent:(id<RTRNode>)node {
    for (id<RTRNode> child in [node allChildren]) {
        RTRNodeData *childData = [self.nodeDataStorage dataForNode:child];
        
        RTRNodeState oldState = childData.presentationState;
        RTRNodeState newState = childData.state;
        
        if ((oldState == RTRNodeStateInactive || oldState == RTRNodeStateNotInitialized) && newState == RTRNodeStateActive) {
            childData.presentationState = RTRNodeStateActivating;
        } else if (oldState == RTRNodeStateActive && (newState == RTRNodeStateInactive || newState == RTRNodeStateNotInitialized)) {
            childData.presentationState = RTRNodeStateDeactivating;
        }
    }
    
    [self.nodeDataStorage updateResolvedStateForNodes:self.affectedNodes];
}

- (void)didUpdateNodeContent:(id<RTRNode>)node {
    for (id<RTRNode> child in [node allChildren]) {
        RTRNodeData *childData = [self.nodeDataStorage dataForNode:child];
        childData.presentationState = childData.state;
    }
    
    [self.nodeDataStorage updateResolvedStateForNodes:self.affectedNodes];
}

@end
