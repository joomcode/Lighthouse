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

@property (nonatomic, strong) NSSet *nodesForAnimatedDriverUpdate;

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
    
    [self updateNodesDriver];
    
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
                                                 updateQueue:updateQueue
                                               childrenState:node.childrenState
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

- (void)updateNodesDriver {
    [self updateDriverRecursively:self.components.graph.rootNode];
}

- (void)updateDriverRecursively:(id<RTRNode>)node {
    for (id<RTRNode> childNode in [self.affectedNodes nextItems:node]) {
        [self updateDriverRecursively:childNode];
    }
        
    [self updateDriver:node];
}

- (void)updateDriver:(id<RTRNode>)node {
    RTRNodeData *data = [self.components.nodeDataStorage dataForNode:node];
    RTRTaskQueue *localUpdateQueue = [[RTRTaskQueue alloc] init];
    
    NSAssert(data.driver != nil, @""); // TODO
    
    [self.driverUpdateQueue runTaskWithBlock:^{
        [self willUpdateDriver:node];
    }];
    
    [self.driverUpdateQueue runAsyncTaskWithBlock:^(RTRTaskCompletionBlock completion) {
        [self updateDriverForNode:node withUpdateQueue:localUpdateQueue];
        
        [localUpdateQueue runTaskWithBlock:^{
            completion();
        }];
    }];
    
    [self.driverUpdateQueue runTaskWithBlock:^{
        [self didUpdateDriver:node];
    }];
}

- (void)willUpdateDriver:(id<RTRNode>)node {
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

- (void)didUpdateDriver:(id<RTRNode>)node {
    for (id<RTRNode> child in [node allChildren]) {
        RTRNodeData *childData = [self.components.nodeDataStorage dataForNode:child];
        childData.presentationState = childData.state;
    }
    
    [self.components.nodeDataStorage updateResolvedStateForAffectedNodeTree:self.affectedNodes];
}

@end