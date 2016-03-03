//
//  LHRouterStateImpl.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 03/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHRouterStateImpl.h"
#import "LHNode.h"
#import "LHNodeTree.h"

@interface LHRouterStateImpl ()

@property (nonatomic, strong) id<LHNode> rootNode;

@property (nonatomic, strong, readonly) NSMutableSet<id<LHNode>> *initializedNodes;

@property (nonatomic, strong, readonly) NSMapTable<id<LHNode>, NSNumber *> *nodeStates;

@end


@implementation LHRouterStateImpl

#pragma mark - Init

- (instancetype)initWithRootNode:(id<LHNode>)rootNode {
    self = [super init];
    if (!self) return nil;
    
    _rootNode = rootNode;
    _initializedNodes = [NSMutableSet set];
    _nodeStates = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    LHRouterStateImpl *copy = [[[self class] allocWithZone:zone] init];
    copy->_rootNode = _rootNode;
    copy->_initializedNodes = [_initializedNodes mutableCopy];
    copy->_nodeStates = [_nodeStates copy];
    return copy;
}

#pragma mark - LHRouterState

- (LHNodeState)stateForNode:(id<LHNode>)node {
    return [self.nodeStates objectForKey:node].integerValue;
}

- (NSSet<id<LHNode>> *)nodesWithStates:(LHNodeStateMask)states {
    if (states == LHNodeStateMaskAll) {
        return [LHNodeTree treeWithDescendantsOfNode:self.rootNode].allItems;
    }
    
    if (states == LHNodeStateMaskInitialized) {
        return [self.initializedNodes copy];
    }
    
    NSSet<id<LHNode>> *allNodes = [self nodesWithStates:LHNodeStateMaskAll];
    
    return [allNodes filteredSetUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id<LHNode> node, NSDictionary<NSString *, id> *bindings) {
        LHNodeState nodeState = [self stateForNode:node];
        return (states & LHNodeStateMaskWithState(nodeState));
    }]];
}

#pragma mark - Update

- (NSArray<id<LHNode>> *)updateForAffectedNodeTree:(LHNodeTree *)affectedNodeTree
                                    nodeStateBlock:(LHNodeState (^)(id<LHNode> node))nodeStateBlock {
    NSMutableArray<id<LHNode>> *updatedNodes = [NSMutableArray array];
    
    [self updateRecursivelyForAffectedNodeTree:affectedNodeTree
                                nodeStateBlock:nodeStateBlock
                                    parentNode:nil
                           parentResolvedState:LHNodeStateActive
                                  updatedNodes:updatedNodes];
    
    return updatedNodes;
}

- (void)updateRecursivelyForAffectedNodeTree:(LHNodeTree *)affectedNodeTree
                              nodeStateBlock:(LHNodeState (^)(id<LHNode> node))nodeStateBlock
                                  parentNode:(id<LHNode>)parentNode
                         parentResolvedState:(LHNodeState)parentResolvedState
                                updatedNodes:(NSMutableArray<id<LHNode>> *)updatedNodes {
    
    for (id<LHNode> node in [affectedNodeTree nextItems:parentNode]) {
        LHNodeState oldResolvedState = [self stateForNode:node];

        LHNodeState newState = nodeStateBlock(node);
        LHNodeState newResolvedState = MIN(newState, parentResolvedState);
        
        if (oldResolvedState != newResolvedState) {
            [self.nodeStates setObject:@(newResolvedState) forKey:node];
            
            if (LHNodeStateMaskWithState(newResolvedState) & LHNodeStateMaskInitialized) {
                [self.initializedNodes addObject:node];
            } else {
                [self.initializedNodes removeObject:node];
            }

            [updatedNodes addObject:node];
        }
        
        [self updateRecursivelyForAffectedNodeTree:affectedNodeTree
                                    nodeStateBlock:nodeStateBlock
                                        parentNode:node
                               parentResolvedState:newResolvedState
                                      updatedNodes:updatedNodes];
    }
}

@end
