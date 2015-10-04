//
//  RTRNodeDataStorage.m
//  Router
//
//  Created by Nick Tymchenko on 24/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRNodeDataStorage.h"
#import "RTRNodeData.h"
#import "RTRNode.h"
#import "RTRNodeTree.h"

@interface RTRNodeDataStorage ()

@property (nonatomic, strong, readonly) NSMapTable *dataByNode;

@property (nonatomic, strong) NSMutableSet *resolvedInitializedNodes;
@property (nonatomic, strong) NSMapTable *resolvedStateByNode;

@end


@implementation RTRNodeDataStorage

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

- (BOOL)hasDataForNode:(id<RTRNode>)node {
    return [self.dataByNode objectForKey:node] != nil;
}

- (RTRNodeData *)dataForNode:(id<RTRNode>)node {
    RTRNodeData *data = [self.dataByNode objectForKey:node];
    if (!data) {
        data = [[RTRNodeData alloc] initWithNode:node];
        
        [self.dataByNode setObject:data forKey:node];
        [self.delegate nodeDataStorage:self didCreateData:data forNode:node];
    }
    return data;
}

- (void)resetDataForNode:(id<RTRNode>)node {
    if (![self hasDataForNode:node]) {
        return;
    }
    
    [self.delegate nodeDataStorage:self willResetData:[self.dataByNode objectForKey:node] forNode:node];
    [self.dataByNode removeObjectForKey:node];
}

#pragma mark - State

- (RTRNodeState)resolvedStateForNode:(id<RTRNode>)node {
    return [[self.resolvedStateByNode objectForKey:node] integerValue];
}

- (void)updateResolvedStateForAffectedNodeTree:(RTRNodeTree *)nodeTree {
    [self updateResolvedNodeStateRecursivelyForNodeTree:nodeTree
                                             parentNode:nil
                                    parentResolvedState:RTRNodeStateActive];
}

- (void)updateResolvedNodeStateRecursivelyForNodeTree:(RTRNodeTree *)nodeTree
                                           parentNode:(id<RTRNode>)parentNode
                                  parentResolvedState:(RTRNodeState)parentResolvedState
{
    for (id<RTRNode> node in [nodeTree nextItems:parentNode]) {
        RTRNodeState oldResolvedState = [self resolvedStateForNode:node];
        
        RTRNodeState newPresentationState = [self hasDataForNode:node] ? [self dataForNode:node].presentationState : RTRNodeStateNotInitialized;
        
        RTRNodeState newResolvedState = MIN(newPresentationState, parentResolvedState);
        
        if (oldResolvedState != newResolvedState) {
            [self willChangeValueForKey:@"resolvedInitializedNodes"];
            
            if (newResolvedState == RTRNodeStateNotInitialized) {
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
