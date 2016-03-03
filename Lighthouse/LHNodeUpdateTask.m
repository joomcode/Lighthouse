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
#import "LHDriver.h"
#import "LHTaskQueue.h"
#import "LHNode.h"
#import "LHNodeChildrenState.h"
#import "LHNodeTree.h"
#import "LHNodeUtils.h"
#import "LHDriverUpdateContext.h"
#import "LHDriverChannelImpl.h"


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
        self.nodesForAnimatedDriverUpdate = [self.components.graph activeNodesTree].allItems;
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

- (void)updateDriverForNode:(id<LHNode>)node withUpdateQueue:(LHTaskQueue *)updateQueue {
    id<LHDriver> driver = [self.components.nodeDataStorage dataForNode:node].driver;
    
    LHDriverUpdateContext *context = [[LHDriverUpdateContext alloc] initWithAnimated:[self.nodesForAnimatedDriverUpdate containsObject:node]
                                                                             command:[self command]
                                                                       childrenState:node.childrenState
                                                                         updateQueue:updateQueue];
    
    [driver updateWithContext:context];
}

#pragma mark - Node state manipulation

- (void)markAffectedNodes {
    LHNodeTree *tree = [self.components.graph initializedNodesTree];
    
    [tree enumerateItemsWithBlock:^(id<LHNode> node, id<LHNode> previousNode, BOOL *stop) {
        [self.affectedNodes addItem:node afterItemOrNil:previousNode];
    }];
}

- (void)cleanupAffectedNodes {
    [self.affectedNodes enumerateItemsWithBlock:^(id<LHNode> node, id<LHNode> previousNode, BOOL *stop) {
        [LHNodeUtils enumerateChildrenOfNode:node withBlock:^(id<LHNode> childNode, LHNodeModelState childModelState) {
            if (childModelState == LHNodeModelStateNotInitialized) {
                [self.components.nodeDataStorage resetDataForNode:childNode];
            }
        }];
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
    
    if (!data.driver) {
        [NSException raise:NSInternalInconsistencyException format:@"Expected a driver for node %@, got nothing - something went wrong", node];
    }
    
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
        LHNodeData *childData = [self.components.nodeDataStorage dataForNode:childNode];
        childData.state = LHNodeStateForTransition(childData.state, childModelState);
    }];
    
    [self.components.nodeDataStorage updateResolvedStateForAffectedNodeTree:self.affectedNodes];
}

- (void)didUpdateDriverForNode:(id<LHNode>)node {
    [LHNodeUtils enumerateChildrenOfNode:node withBlock:^(id<LHNode> childNode, LHNodeModelState childModelState) {
        LHNodeData *childData = [self.components.nodeDataStorage dataForNode:childNode];
        childData.state = LHNodeStateWithModelState(childModelState);
    }];
    
    [self.components.nodeDataStorage updateResolvedStateForAffectedNodeTree:self.affectedNodes];
}

@end
