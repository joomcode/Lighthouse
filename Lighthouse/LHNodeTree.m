//
//  LHNodeTree.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNodeTree.h"
#import "LHNode.h"
#import "LHNodeChildrenState.h"

@implementation LHNodeTree

#pragma mark - Public

+ (instancetype)treeWithDescendantsOfNode:(id<LHNode>)node withStates:(LHNodeStateMask)stateMask {
    LHNodeTree *tree = [[LHNodeTree alloc] init];
    [tree addItem:node afterItemOrNil:nil];
    [self collectChildrenOfNode:node withStates:stateMask toTree:tree];
    return tree;
}

#pragma mark - Private

+ (void)collectChildrenOfNode:(id<LHNode>)node
                   withStates:(LHNodeStateMask)stateMask
                       toTree:(LHNodeTree *)tree {
    if (stateMask == LHNodeStateMaskAll) {
        // Let's make this optimization.
        [tree addFork:node.allChildren.allObjects afterItemOrNil:node];
    } else {
        id<LHNodeChildrenState> childrenState = node.childrenState;
        
        if (stateMask & LHNodeStateMaskActive) {
            for (id<LHNode> child in childrenState.activeChildren) {
                [tree addItem:child afterItemOrNil:node];
            }
        }
        
        if (stateMask & LHNodeStateMaskInactive) {
            for (id<LHNode> child in childrenState.initializedChildren) {
                if (![childrenState.activeChildren containsObject:child]) {
                    [tree addItem:child afterItemOrNil:node];
                }
            }
        }
        
        if (stateMask & LHNodeStateMaskNotInitialized) {
            for (id<LHNode> child in node.allChildren) {
                if (![childrenState.initializedChildren containsObject:child]) {
                    [tree addItem:child afterItemOrNil:node];
                }
            }
        }
    }
    
    for (id<LHNode> child in [tree nextItems:node]) {
        [self collectChildrenOfNode:child withStates:stateMask toTree:tree];
    }
}

@end
