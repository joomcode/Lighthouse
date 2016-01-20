//
//  LHNodeUpdateTask.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHNodeUpdateTask.h"
#import "LHComponents.h"
#import "LHNodeDataStorage.h"
#import "LHNodeData.h"
#import "LHGraph.h"
#import "LHDriverProvider.h"
#import "LHDriver.h"
#import "LHTaskQueue.h"
#import "LHNode.h"
#import "LHNodeChildrenState.h"
#import "LHNodeTree.h"
#import "LHDriverUpdateContextImpl.h"
#import "LHDriverFeedbackChannelImpl.h"


@interface LHNodeUpdateTask ()

@property (nonatomic, strong, readonly) LHTaskQueue *driverUpdateQueue;

@property (nonatomic, strong, readonly) LHNodeTree *affectedNodes;

@property (nonatomic, strong) NSSet<id<LHNode>> *nodesForAnimatedDriverUpdate;

@property (nonatomic, assign, getter = isCancelled) BOOL cancelled;

@end


@implementation LHNodeUpdateTask

#pragma mark - Init

- (instancetype)initWithComponents:(LHComponents *)components animated:(BOOL)animated {
    self = [super init];
    if (!self) return nil;
    
    _components = components;
    _animated = animated;
    
    _driverUpdateQueue = [[LHTaskQueue alloc] init];
    
    _affectedNodes = [[LHNodeTree alloc] init];
    [_affectedNodes addItem:_components.graph.rootNode afterItemOrNil:nil];
    
    return self;
}

#pragma mark - LHTask

- (void)startWithCompletionBlock:(LHTaskCompletionBlock)completionBlock {
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

- (id<LHCommand>)command {
    return nil;
}

- (void)updateNodes {
}

- (void)updateDriverForNode:(id<LHNode>)node withUpdateQueue:(LHTaskQueue *)updateQueue {
    id<LHDriver> driver = [self.components.nodeDataStorage dataForNode:node].driver;
    
    id<LHDriverUpdateContext> updateContext =
        [[LHDriverUpdateContextImpl alloc] initWithAnimated:[self.nodesForAnimatedDriverUpdate containsObject:node]
                                                     command:[self command]
                                               childrenState:node.childrenState
                                                 updateQueue:updateQueue
                                                 driverBlock:^id<LHDriver>(id<LHNode> node) {
                                                     return [self.components.nodeDataStorage dataForNode:node].driver;
                                                 }];
    
    [driver updateWithContext:updateContext];
}

#pragma mark - Node state manipulation

- (void)markAffectedNodes {
    LHNodeTree *tree = [self.components.graph initializedNodesTree];
    
    [tree enumerateItemsWithBlock:^(id<LHNode> node, id<LHNode> previousNode, BOOL *stop) {
        [self.affectedNodes addItem:node afterItemOrNil:previousNode];
    }];
}

- (void)updateAffectedNodesState {
    [self.affectedNodes enumerateItemsWithBlock:^(id<LHNode> node, id<LHNode> previousNode, BOOL *stop) {
        if (!previousNode) {
            LHNodeData *data = [self.components.nodeDataStorage dataForNode:node];
            data.state = LHNodeStateActive;
            data.presentationState = LHNodePresentationStateActive;
        }
        
        for (id<LHNode> childNode in [self.affectedNodes nextItems:node]) {
            LHNodeState childState;
            
            // TODO: move this code somewhere
            if ([node.childrenState.activeChildren containsObject:childNode]) {
                childState = LHNodeStateActive;
            } else if ([node.childrenState.initializedChildren containsObject:childNode]) {
                childState = LHNodeStateInactive;
            } else {
                childState = LHNodeStateNotInitialized;
            }
            
            [self.components.nodeDataStorage dataForNode:childNode].state = childState;
        }
    }];
}

- (void)cleanupAffectedNodes {
    [self.affectedNodes enumerateItemsWithBlock:^(id<LHNode> node, id<LHNode> previousNode, BOOL *stop) {
        if (previousNode && ![previousNode.childrenState.initializedChildren containsObject:node]) {
            [self.components.nodeDataStorage resetDataForNode:node];
        }
    }];
}

#pragma mark - Driver manipulation

- (void)updateDrivers {
    [self updateDriversRecursively:self.components.graph.rootNode];
}

- (void)updateDriversRecursively:(id<LHNode>)node {
    for (id<LHNode> childNode in [self.affectedNodes nextItems:node]) {
        [self updateDriversRecursively:childNode];
    }
        
    [self updateDriverForNode:node];
}

- (void)updateDriverForNode:(id<LHNode>)node {
    LHNodeData *data = [self.components.nodeDataStorage dataForNode:node];
    LHTaskQueue *localUpdateQueue = [[LHTaskQueue alloc] init];
    
    NSAssert(data.driver != nil, @""); // TODO
    
    [self.driverUpdateQueue runTaskWithBlock:^{
        [self willUpdateDriverForNode:node];
    }];
    
    [self.driverUpdateQueue runAsyncTaskWithBlock:^(LHTaskCompletionBlock completion) {
        [self updateDriverForNode:node withUpdateQueue:localUpdateQueue];
        
        [localUpdateQueue runTaskWithBlock:^{
            completion();
        }];
    }];
    
    [self.driverUpdateQueue runTaskWithBlock:^{
        [self didUpdateDriverForNode:node];
    }];
}

- (void)willUpdateDriverForNode:(id<LHNode>)node {
    for (id<LHNode> child in [node allChildren]) {
        LHNodeData *childData = [self.components.nodeDataStorage dataForNode:child];
        childData.presentationState = LHNodePresentationStateForTransition(childData.presentationState, childData.state);
    }
    
    [self.components.nodeDataStorage updateResolvedStateForAffectedNodeTree:self.affectedNodes];
}

- (void)didUpdateDriverForNode:(id<LHNode>)node {
    for (id<LHNode> child in [node allChildren]) {
        LHNodeData *childData = [self.components.nodeDataStorage dataForNode:child];
        childData.presentationState = LHNodePresentationStateWithState(childData.state);
    }
    
    [self.components.nodeDataStorage updateResolvedStateForAffectedNodeTree:self.affectedNodes];
}

@end
