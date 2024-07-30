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
#import "LHRouterState.h"
#import "LHNodeData.h"
#import "LHDriver.h"
#import "LHTaskQueueImpl.h"
#import "LHNode.h"
#import "LHNodeChildrenState.h"
#import "LHNodeTree.h"
#import "LHNodeUtils.h"
#import "LHDriverUpdateContext.h"
#import "LHDriverChannelImpl.h"
#import "LHStackNode.h"


@interface LHNodeUpdateTask ()

@property (nonatomic, strong, readonly) id<LHTaskQueue> driverUpdateQueue;

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
    
    _driverUpdateQueue = [[LHTaskQueueImpl alloc] init];
    
    _affectedNodes = [[LHNodeTree alloc] init];
    [_affectedNodes addItem:components.tree.rootItem afterItemOrNil:nil];
    
    return self;
}

#pragma mark - LHTask

- (void)startWithCompletionBlock:(LHTaskCompletionBlock)completionBlock {
    if (self.animated) {
        self.nodesForAnimatedDriverUpdate = [self.components.tree activeNodesTree].allItems;
    }
    
    [self markAffectedNodes];
    
    [self updateNodesWithCompletion:^{
        [self markAffectedNodes];
        
        [self updateDrivers];
        
        [self.driverUpdateQueue runTaskWithBlock:^{
            if (!self.cancelled) {
                [self cleanupAffectedNodes];
            }
            
            completionBlock();
        }];
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

- (void)updateNodesWithCompletion:(LHTaskCompletionBlock)completion {
    completion();
}

- (void)updateDriverForNode:(id<LHNode>)node withUpdateQueue:(id<LHTaskQueue>)updateQueue {
    id<LHDriver> driver = [self.components.nodeDataStorage dataForNode:node].drivers.lastObject;

    LHDriverUpdateContext *context = [[LHDriverUpdateContext alloc] initWithAnimated:[self.nodesForAnimatedDriverUpdate containsObject:node]
                                                                             command:[self command]
                                                                       childrenState:node.childrenState
                                                                         updateQueue:updateQueue];
    [driver updateWithContext:context];
}

#pragma mark - Node state manipulation

- (void)markAffectedNodes {
    LHNodeTree *tree = [self.components.tree initializedNodesTree];
    
    [tree enumerateItemsWithBlock:^(id<LHNode> node, id<LHNode> previousNode, BOOL *stop) {
        [self.affectedNodes addItem:node afterItemOrNil:previousNode];
    }];
}

- (void)cleanupAffectedNodes {
    [self.affectedNodes enumerateItemsWithBlock:^(id<LHNode> node, id<LHNode> previousNode, BOOL *stop) {
        if ([self.components.nodeDataStorage.routerState stateForNode:node] == LHNodeStateNotInitialized) {
            [self.components.nodeDataStorage resetDataForNode:node];
        } else if ([self shouldRemoveDriverForNode:node]) {
            [self.components.nodeDataStorage removeDriverForNode:node];
        }
    }];
}

#pragma mark - Driver manipulation

- (void)updateDrivers {
    [self updateDriversRecursively:self.components.tree.rootItem];
}

- (void)updateDriversRecursively:(id<LHNode>)node {
    for (id<LHNode> childNode in [self.affectedNodes nextItems:node]) {
        [self updateDriversRecursively:childNode];
    }
    
    [self updateDriverForNode:node];
}

- (NSInteger)numberOfDriversNeededForNode:(id<LHNode>)node {
    id<LHNode> parent = [self.components.tree previousItem:node];
    if ([parent isKindOfClass:[LHStackNode class]]) {
        LHStackNode *stackNode = (LHStackNode *)parent;
        
        NSInteger nodeCount = 0;
        for (id<LHNode> child in stackNode.childrenState.stack) {
            if (child == node) {
                ++nodeCount;
            }
        }
        return nodeCount;
    }
    return 1;
}

- (BOOL)shouldCreateDriverForNode:(id<LHNode>)node {
    return [self numberOfDriversNeededForNode:node] > [self.components.nodeDataStorage dataForNode:node].drivers.count;
}

- (BOOL)shouldRemoveDriverForNode:(id<LHNode>)node {
    return [self numberOfDriversNeededForNode:node] < [self.components.nodeDataStorage dataForNode:node].drivers.count;
}

- (void)updateDriverForNode:(id<LHNode>)node {
    LHNodeData *data = [self.components.nodeDataStorage dataForNode:node];
    if ([self shouldCreateDriverForNode:node]) {
        [self.components.nodeDataStorage createDriverForNode:node];
    }
    
    id<LHTaskQueue> localUpdateQueue = [[LHTaskQueueImpl alloc] init];
    
    LHAssert(data.drivers.lastObject != nil, @"Expected a driver for node %@, got nothing - something went wrong", node);

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
    [LHNodeUtils enumerateChildrenOfNode:node withBlock:^(id<LHNode> childNode, LHNodeModelState childModelState) {
        if ([self.components.nodeDataStorage hasDataForNode:childNode]) {
            LHNodeData *childData = [self.components.nodeDataStorage dataForNode:childNode];
            childData.state = LHNodeStateForTransition(childData.state, childModelState);
        }
    }];
    
    [self.components.nodeDataStorage updateRouterStateForAffectedNodeTree:self.affectedNodes];
}

- (void)didUpdateDriverForNode:(id<LHNode>)node {
    [LHNodeUtils enumerateChildrenOfNode:node withBlock:^(id<LHNode> childNode, LHNodeModelState childModelState) {
        if ([self.components.nodeDataStorage hasDataForNode:childNode]) {
            LHNodeData *childData = [self.components.nodeDataStorage dataForNode:childNode];
            childData.state = LHNodeStateWithModelState(childModelState);
        }
    }];
    
    [self.components.nodeDataStorage updateRouterStateForAffectedNodeTree:self.affectedNodes];
}

@end
