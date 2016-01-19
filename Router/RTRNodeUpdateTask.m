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
#import "RTRDriverProvider.h"
#import "RTRDriver.h"
#import "RTRTaskQueue.h"
#import "RTRNode.h"
#import "RTRNodeChildrenState.h"
#import "RTRNodeTree.h"
#import "RTRDriverUpdateContextImpl.h"
#import "RTRDriverFeedbackChannelImpl.h"


@interface RTRNodeUpdateTask ()

@property (nonatomic, strong, readonly) RTRTaskQueue *driverUpdateQueue;

@property (nonatomic, strong, readonly) RTRNodeTree *affectedNodes;

@property (nonatomic, strong) NSSet<id<RTRNode>> *nodesForAnimatedDriverUpdate;

@property (nonatomic, assign, getter = isCancelled) BOOL cancelled;

@end


@implementation RTRNodeUpdateTask

#pragma mark - Init

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated {
    self = [super init];
    if (!self) return nil;
    
    _components = components;
    _animated = animated;
    
    _driverUpdateQueue = [[RTRTaskQueue alloc] init];
    
    _affectedNodes = [[RTRNodeTree alloc] init];
    [_affectedNodes addItem:_components.graph.rootNode afterItemOrNil:nil];
    
    return self;
}

#pragma mark - RTRTask

- (void)startWithCompletionBlock:(RTRTaskCompletionBlock)completionBlock {
    if (self.animated) {
        self.nodesForAnimatedDriverUpdate = [[self.components.graph activeNodesTree] allItems];
    }
    
    [self markAffectedNodes];
    [self updateNodes];
    [self markAffectedNodes];
    
    [self updateAffectedNodesState];
    
    [self updateDrivers];
    
    [self.driverUpdateQueue runTaskWithBlock:^{
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
    // e.g. is there a way to cancel ongoing node driver update?
}

#pragma mark - Subclassing

- (id<RTRCommand>)command {
    return nil;
}

- (void)updateNodes {
}

- (void)updateDriverForNode:(id<RTRNode>)node withUpdateQueue:(RTRTaskQueue *)updateQueue {
    id<RTRDriver> driver = [self.components.nodeDataStorage dataForNode:node].driver;
    
    id<RTRDriverUpdateContext> updateContext =
        [[RTRDriverUpdateContextImpl alloc] initWithAnimated:[self.nodesForAnimatedDriverUpdate containsObject:node]
                                                     command:[self command]
                                               childrenState:node.childrenState
                                                 updateQueue:updateQueue
                                                 driverBlock:^id<RTRDriver>(id<RTRNode> node) {
                                                     return [self.components.nodeDataStorage dataForNode:node].driver;
                                                 }];
    
    [driver updateWithContext:updateContext];
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

#pragma mark - Driver manipulation

- (void)updateDrivers {
    [self updateDriversRecursively:self.components.graph.rootNode];
}

- (void)updateDriversRecursively:(id<RTRNode>)node {
    for (id<RTRNode> childNode in [self.affectedNodes nextItems:node]) {
        [self updateDriversRecursively:childNode];
    }
        
    [self updateDriverForNode:node];
}

- (void)updateDriverForNode:(id<RTRNode>)node {
    RTRNodeData *data = [self.components.nodeDataStorage dataForNode:node];
    RTRTaskQueue *localUpdateQueue = [[RTRTaskQueue alloc] init];
    
    NSAssert(data.driver != nil, @""); // TODO
    
    [self.driverUpdateQueue runTaskWithBlock:^{
        [self willUpdateDriverForNode:node];
    }];
    
    [self.driverUpdateQueue runAsyncTaskWithBlock:^(RTRTaskCompletionBlock completion) {
        [self updateDriverForNode:node withUpdateQueue:localUpdateQueue];
        
        [localUpdateQueue runTaskWithBlock:^{
            completion();
        }];
    }];
    
    [self.driverUpdateQueue runTaskWithBlock:^{
        [self didUpdateDriverForNode:node];
    }];
}

- (void)willUpdateDriverForNode:(id<RTRNode>)node {
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

- (void)didUpdateDriverForNode:(id<RTRNode>)node {
    for (id<RTRNode> child in [node allChildren]) {
        RTRNodeData *childData = [self.components.nodeDataStorage dataForNode:child];
        childData.presentationState = childData.state;
    }
    
    [self.components.nodeDataStorage updateResolvedStateForAffectedNodeTree:self.affectedNodes];
}

@end
