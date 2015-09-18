//
//  RTRRouter.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRRouter.h"
#import "RTRRouterDelegate.h"
#import "RTRNode.h"
#import "RTRNodeContent.h"
#import "RTRGraph.h"
#import "RTRNodeData.h"
#import "RTRCommandRegistry.h"
#import "RTRNodeContentProvider.h"
#import "RTRNodeChildrenState.h"
#import "RTRTaskQueueImpl.h"
#import "RTRNodeContentUpdateContextImpl.h"
#import "RTRNodeContentFeedbackChannelImpl.h"

NSString * const RTRRouterNodeStateDidUpdateNotification = @"com.pixty.router.nodeStateDidUpdate";


@interface RTRRouter ()

@property (nonatomic, strong, readonly) id<RTRTaskQueue> commandQueue;
@property (nonatomic, strong, readonly) id<RTRTaskQueue> contentUpdateQueue;

@property (nonatomic, strong) RTRGraph *graph;

@property (nonatomic, strong, readonly) NSMapTable *dataByNode;

@property (nonatomic, strong) NSSet *initializedNodes;

@property (nonatomic, strong) NSMapTable *resolvedStateByNode;

@end


@implementation RTRRouter

#pragma mark - Task queues

@synthesize commandQueue = _commandQueue;
@synthesize contentUpdateQueue = _contentUpdateQueue;

- (id<RTRTaskQueue>)commandQueue {
    if (!_commandQueue) {
        _commandQueue = [[RTRTaskQueueImpl alloc] init];
    }
    return _commandQueue;
}

- (id<RTRTaskQueue>)contentUpdateQueue {
    if (!_contentUpdateQueue) {
        _contentUpdateQueue = [[RTRTaskQueueImpl alloc] init];
    }
    return _contentUpdateQueue;
}

#pragma mark - Config stuff

- (id<RTRNode>)rootNode {
    return self.graph.rootNode;
}

- (void)setRootNode:(id<RTRNode>)rootNode {
    self.graph = [[RTRGraph alloc] initWithRootNode:rootNode];
}

#pragma mark - Command execution

- (void)executeCommand:(id<RTRCommand>)command animated:(BOOL)animated {
    [self.commandQueue runAsyncTaskWithBlock:^(RTRTaskQueueAsyncCompletionBlock completion) {
        id<RTRNode> targetNode = [self.commandRegistry nodeForCommand:command];
        NSAssert(targetNode != nil, @""); // TODO
        
        NSOrderedSet *pathToTargetNode = [self.graph pathToNode:targetNode];
        NSAssert(pathToTargetNode != nil, @""); // TODO
        
        NSSet *nodesForAnimatedContentUpdate = animated ? [self nodesForAnimatedContentUpdateForTargetNodePath:pathToTargetNode] : nil;
        
        [self activateNodePath:pathToTargetNode];
        
        [self updateNodeContentRecursively:pathToTargetNode[0] withCommand:command animateNodes:nodesForAnimatedContentUpdate];
        
        [self.contentUpdateQueue runTaskWithBlock:^{
            [self cleanupNodePath:pathToTargetNode];
            completion();
        }];
    }];
}

#pragma mark - Node state manipulation

- (void)activateNodePath:(NSOrderedSet *)nodePath {
    for (NSInteger i = 0; i < nodePath.count; ++i) {
        if (i == 0) {
            [self dataForNode:nodePath[0]].state = RTRNodeStateActive;
            [self dataForNode:nodePath[0]].presentationState = RTRNodeStateActive;
        } else {
            [self activateNewChildNode:nodePath[i] ofParentNode:nodePath[i - 1]];
        }
    }
}

- (void)activateNewChildNode:(id<RTRNode>)childNode ofParentNode:(id<RTRNode>)parentNode {
    RTRNodeData *parentData = [self dataForNode:parentNode];
    parentData.childrenState = [parentNode activateChild:childNode withCurrentState:parentData.childrenState];
    
    [self updateNodeChildrenState:parentNode];
}

- (void)updateNodeChildrenState:(id<RTRNode>)parentNode {
    id<RTRNodeChildrenState> childrenState = [self dataForNode:parentNode].childrenState;
    
    for (id<RTRNode> childNode in childrenState.initializedChildren) {
        [self dataForNode:childNode].state = [childrenState.activeChildren containsObject:childNode] ? RTRNodeStateActive : RTRNodeStateInactive;
    }
    
    for (id<RTRNode> childNode in [parentNode allChildren]) {
        if (![childrenState.initializedChildren containsObject:childNode]) {
            [self dataForNode:childNode].state = RTRNodeStateNotInitialized;
        }
    }
}

- (void)cleanupNodePath:(NSOrderedSet *)nodePath {
    for (id<RTRNode> node in nodePath) {
        RTRNodeData *nodeData = [self dataForNode:node];
        
        for (id<RTRNode> childNode in [node allChildren]) {
            if (![nodeData.childrenState.initializedChildren containsObject:childNode]) {
                [self resetDataForNode:childNode];
            }
        }
    }
}

#pragma mark - Node content manipulation

- (NSSet *)nodesForAnimatedContentUpdateForTargetNodePath:(NSOrderedSet *)nodePath {
    NSInteger firstInactiveNodeIndex = [self firstInactiveNodeIndexForTargetNodePath:nodePath];
    
    if (firstInactiveNodeIndex == NSNotFound) {
        return [nodePath set];
    } else {
        return [NSSet setWithArray:[[nodePath array] subarrayWithRange:NSMakeRange(0, MAX(1, firstInactiveNodeIndex))]];
    }
}

- (NSInteger)firstInactiveNodeIndexForTargetNodePath:(NSOrderedSet *)nodePath {
    for (NSInteger i = 0; i < nodePath.count; ++i) {
        RTRNodeData *data = [self dataForNode:nodePath[i]];
        
        if (data.state != RTRNodeStateActive) {
            return i;
        }
    }
    
    return NSNotFound;
}

- (void)updateNodeContentRecursively:(id<RTRNode>)node withCommand:(id<RTRCommand>)command animateNodes:(NSSet *)animatedNodes {
    RTRNodeData *data = [self dataForNode:node];
    
    for (id<RTRNode> childNode in data.childrenState.initializedChildren) {
        [self updateNodeContentRecursively:childNode withCommand:command animateNodes:animatedNodes];
    }
    
    [self updateNodeContent:node withCommand:command animated:[animatedNodes containsObject:node]];
}

- (void)updateNodeContent:(id<RTRNode>)node withCommand:(id<RTRCommand>)command animated:(BOOL)animated {
    RTRNodeData *data = [self dataForNode:node];
    
    if (!data.content) {
        data.content = [self createContentForNode:node];
    }
    
    [self.contentUpdateQueue runTaskWithBlock:^{
        [self willUpdateNodeContent:node];
    }];
    
    id<RTRTaskQueue> localUpdateQueue = [[RTRTaskQueueImpl alloc] init];
    
    [self.contentUpdateQueue runAsyncTaskWithBlock:^(RTRTaskQueueAsyncCompletionBlock completion) {
        id<RTRNodeContentUpdateContext> updateContext =
            [[RTRNodeContentUpdateContextImpl alloc] initWithAnimated:animated
                                                              command:command
                                                          updateQueue:localUpdateQueue
                                                        childrenState:data.childrenState
                                                         contentBlock:^id<RTRNodeContent>(id<RTRNode> node) {
                                                             return [self dataForNode:node].content;
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
        
        id<RTRNodeContentFeedbackChannel> feedbackChannel =
            [[RTRNodeContentFeedbackChannelImpl alloc] initWithWillBecomeActiveBlock:^(id<RTRNode> child) {
                [weakSelf activateNewChildNode:child ofParentNode:node];
                [weakSelf willUpdateNodeContent:node];
            } didBecomeActiveBlock:^(id<RTRNode> child) {
                [weakSelf didUpdateNodeContent:node];
            }];
        
        content.feedbackChannel = feedbackChannel;
    }
    
    return content;
}

- (void)willUpdateNodeContent:(id<RTRNode>)node {
    for (id<RTRNode> child in [node allChildren]) {
        RTRNodeData *childData = [self dataForNode:child];
        
        RTRNodeState oldState = childData.presentationState;
        RTRNodeState newState = childData.state;
        
        if ((oldState == RTRNodeStateInactive || oldState == RTRNodeStateNotInitialized) && newState == RTRNodeStateActive) {
            childData.presentationState = RTRNodeStateActivating;
        } else if (oldState == RTRNodeStateActive && (newState == RTRNodeStateInactive || newState == RTRNodeStateNotInitialized)) {
            childData.presentationState = RTRNodeStateDeactivating;
        }
    }
    
    [self updateResolvedNodeState];
}

- (void)didUpdateNodeContent:(id<RTRNode>)node {
    for (id<RTRNode> child in [node allChildren]) {
        RTRNodeData *childData = [self dataForNode:child];
        childData.presentationState = childData.state;
    }
    
    [self updateResolvedNodeState];
}

#pragma mark - Node content state query

- (RTRNodeState)stateForNode:(id<RTRNode>)node {
    NSNumber *state = [self.resolvedStateByNode objectForKey:node];
    return [state integerValue];
}

- (void)updateResolvedNodeState {
    NSMapTable *resolvedStateByNode = [self calculateResolvedNodeState];
    if ([resolvedStateByNode isEqual:self.resolvedStateByNode]) {
        return;
    }
    self.resolvedStateByNode = resolvedStateByNode;
    
    NSMutableSet *initializedNodes = [NSMutableSet setWithCapacity:self.resolvedStateByNode.count];
    for (id<RTRNode> node in self.resolvedStateByNode) {
        [initializedNodes addObject:node];
    }    
    self.initializedNodes = [initializedNodes copy];
    
    [self.delegate routerNodeStateDidUpdate:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:RTRRouterNodeStateDidUpdateNotification object:self];
}

- (NSMapTable *)calculateResolvedNodeState {
    NSMapTable *resolvedStateByNode = [NSMapTable strongToStrongObjectsMapTable];
    
    [self calculateResolvedNodeStateRecursively:resolvedStateByNode withCurrentNode:self.rootNode parentState:RTRNodeStateActive];
    
    return resolvedStateByNode;
}

- (void)calculateResolvedNodeStateRecursively:(NSMapTable *)resolvedStateByNode
                              withCurrentNode:(id<RTRNode>)node
                                  parentState:(RTRNodeState)parentState
{
    RTRNodeData *data = [self dataForNode:node];
    
    RTRNodeState state = MIN(data.presentationState, parentState);
    if (state == RTRNodeStateNotInitialized) {
        return;
    }
    
    [resolvedStateByNode setObject:@(state) forKey:node];
    
    for (id<RTRNode> child in [node allChildren]) {
        [self calculateResolvedNodeStateRecursively:resolvedStateByNode withCurrentNode:child parentState:state];
    }
}

#pragma mark - Node data

@synthesize dataByNode = _dataByNode;

- (NSMapTable *)dataByNode {
    if (!_dataByNode) {
        _dataByNode = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _dataByNode;
}

- (RTRNodeData *)dataForNode:(id<RTRNode>)node {
    RTRNodeData *data = [self.dataByNode objectForKey:node];
    if (!data) {
        data = [self createDataForNode:node];
        [self.dataByNode setObject:data forKey:node];
    }
    return data;
}

- (RTRNodeData *)createDataForNode:(id<RTRNode>)node {
    RTRNodeData *data = [[RTRNodeData alloc] init];
    data.childrenState = [node activateChild:[node defaultActiveChild] withCurrentState:nil];
    return data;
}

- (void)resetDataForNode:(id<RTRNode>)node {
    [self.dataByNode removeObjectForKey:node];
}

@end
