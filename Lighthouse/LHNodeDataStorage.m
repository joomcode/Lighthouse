//
//  LHNodeDataStorage.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 24/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHNodeDataStorage.h"
#import "LHNodeData.h"
#import "LHNode.h"
#import "LHNodeTree.h"
#import "LHRouterStateImpl.h"
#import "LHDriver.h"

@interface LHNodeDataStorage ()

@property (nonatomic, strong, readonly) id<LHNode> rootNode;
@property (nonatomic, strong, readonly) NSMapTable<id<LHNode>, LHNodeData *> *dataByNode;

@property (nonatomic, strong) NSMutableSet<id<LHNode>> *resolvedInitializedNodes;
@property (nonatomic, strong) NSMapTable<id<LHNode>, NSNumber *> *resolvedStateByNode;

@property (nonatomic, strong) LHRouterStateImpl *routerState;

@end


@implementation LHNodeDataStorage

#pragma mark - Init

- (instancetype)initWithRootNode:(id<LHNode>)rootNode {
    self = [super init];
    if (!self) return nil;
    
    _rootNode = rootNode;
    _dataByNode = [NSMapTable strongToStrongObjectsMapTable];
    
    _resolvedInitializedNodes = [[NSMutableSet alloc] init];
    _resolvedStateByNode = [NSMapTable strongToStrongObjectsMapTable];
    
    _routerState = [[LHRouterStateImpl alloc] initWithRootNode:rootNode];
    
    return self;
}

#pragma mark - Data

- (BOOL)hasDataForNode:(id<LHNode>)node {
    return [self.dataByNode objectForKey:node] != nil;
}

- (LHNodeData *)dataForNode:(id<LHNode>)node {
    LHNodeData *data = [self.dataByNode objectForKey:node];
    if (!data) {
        data = [[LHNodeData alloc] initWithNode:node];
        
        [self.dataByNode setObject:data forKey:node];
        [self.delegate nodeDataStorage:self didCreateData:data forNode:node];
    }
    return data;
}

- (void)resetDataForNode:(id<LHNode>)node {
    LHNodeData *data = [self.dataByNode objectForKey:node];
    if (!data) {
        return;
    }
    [self.delegate nodeDataStorage:self willResetData:data forNode:node];
    [self.dataByNode removeObjectForKey:node];
}

- (void)createDriverForNode:(id<LHNode>)node {
    LHNodeData *data = [self.dataByNode objectForKey:node];
    NSParameterAssert(data != nil);
    [self.delegate nodeDataStorage:self didCreateData:data forNode:node];
}

- (void)removeDriverNodeNode:(id<LHNode>)node {
    LHNodeData *data = [self.dataByNode objectForKey:node];
    if (!data) {
        return;
    }
    NSMutableArray<id<LHDriver>> *drivers = [data.drivers mutableCopy];
    [drivers removeLastObject];
    data.drivers = drivers;
    
    [self.delegate nodeDataStorage:self willResetData:data forNode:node];
}

#pragma mark - State

- (void)updateRouterStateForAffectedNodeTree:(LHNodeTree *)nodeTree {
    LHRouterStateImpl *updatedRouterState = [self.routerState copy];
    
    NSArray<id<LHNode>> *updatedNodes = [updatedRouterState updateForAffectedNodeTree:nodeTree nodeStateBlock:^LHNodeState(id<LHNode> node) {
        if (node == self.rootNode) {
            return LHNodeStateActive;
        } else {
            return [self hasDataForNode:node] ? [self dataForNode:node].state : LHNodeStateNotInitialized;
        }
    }];
    
    self.routerState = updatedRouterState;

    [self.delegate nodeDataStorage:self didChangeResolvedStateForNodes:updatedNodes];
}

@end
