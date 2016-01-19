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

@interface LHNodeDataStorage ()

@property (nonatomic, strong, readonly) NSMapTable<id<LHNode>, LHNodeData *> *dataByNode;

@property (nonatomic, strong) NSMutableSet<id<LHNode>> *resolvedInitializedNodes;
@property (nonatomic, strong) NSMapTable<id<LHNode>, NSNumber *> *resolvedStateByNode;

@end


@implementation LHNodeDataStorage

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _dataByNode = [NSMapTable strongToStrongObjectsMapTable];
    
    _resolvedInitializedNodes = [[NSMutableSet alloc] init];
    _resolvedStateByNode = [NSMapTable strongToStrongObjectsMapTable];
    
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
    if (![self hasDataForNode:node]) {
        return;
    }
    
    [self.delegate nodeDataStorage:self willResetData:[self.dataByNode objectForKey:node] forNode:node];
    [self.dataByNode removeObjectForKey:node];
}

#pragma mark - State

- (LHNodeState)resolvedStateForNode:(id<LHNode>)node {
    return [[self.resolvedStateByNode objectForKey:node] integerValue];
}

- (void)updateResolvedStateForAffectedNodeTree:(LHNodeTree *)nodeTree {
    [self updateResolvedNodeStateRecursivelyForNodeTree:nodeTree
                                             parentNode:nil
                                    parentResolvedState:LHNodeStateActive];
}

- (void)updateResolvedNodeStateRecursivelyForNodeTree:(LHNodeTree *)nodeTree
                                           parentNode:(id<LHNode>)parentNode
                                  parentResolvedState:(LHNodeState)parentResolvedState
{
    for (id<LHNode> node in [nodeTree nextItems:parentNode]) {
        LHNodeState oldResolvedState = [self resolvedStateForNode:node];
        
        LHNodeState newPresentationState = [self hasDataForNode:node] ? [self dataForNode:node].presentationState : LHNodeStateNotInitialized;
        
        LHNodeState newResolvedState = MIN(newPresentationState, parentResolvedState);
        
        if (oldResolvedState != newResolvedState) {
            [self willChangeValueForKey:@"resolvedInitializedNodes"];
            
            if (newResolvedState == LHNodeStateNotInitialized) {
                [self.resolvedInitializedNodes removeObject:node];
                [self.resolvedStateByNode removeObjectForKey:node];
            } else {
                [self.resolvedInitializedNodes addObject:node];
                [self.resolvedStateByNode setObject:@(newResolvedState) forKey:node];
            }
            
            [self didChangeValueForKey:@"resolvedInitializedNodes"];
            
            [self.delegate nodeDataStorage:self didChangeResolvedStateForNode:node];
        }
        
        [self updateResolvedNodeStateRecursivelyForNodeTree:nodeTree parentNode:node parentResolvedState:newResolvedState];
    }
}

@end
