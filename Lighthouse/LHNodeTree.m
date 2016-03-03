//
//  LHNodeTree.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNodeTree.h"
#import "LHNode.h"
#import "LHNodeUtils.h"
#import "LHNodeModelState.h"

@implementation LHNodeTree

#pragma mark - Public

+ (instancetype)treeWithDescendantsOfNode:(id<LHNode>)node {
    return [self treeWithDescendantsOfNode:node withModelStates:LHNodeModelStateMaskAll];
}

+ (instancetype)treeWithInitializedDescendantsOfNode:(id<LHNode>)node {
    return [self treeWithDescendantsOfNode:node withModelStates:LHNodeModelStateMaskInitialized];
}

+ (instancetype)treeWithActiveDescendantsOfNode:(id<LHNode>)node {
    return [self treeWithDescendantsOfNode:node withModelStates:LHNodeModelStateMaskActive];
}

#pragma mark - Private

+ (instancetype)treeWithDescendantsOfNode:(id<LHNode>)node withModelStates:(LHNodeModelStateMask)modelStateMask {
    LHNodeTree *tree = [[LHNodeTree alloc] init];
    [tree addItem:node afterItemOrNil:nil];
    [self collectChildrenOfNode:node withModelStates:modelStateMask toTree:tree];
    return tree;
}

+ (void)collectChildrenOfNode:(id<LHNode>)node
              withModelStates:(LHNodeModelStateMask)modelStateMask
                       toTree:(LHNodeTree *)tree {
    if (modelStateMask == LHNodeModelStateMaskAll) {
        // Let's make this optimization.
        [tree addFork:node.allChildren.allObjects afterItemOrNil:node];
    } else {
        [LHNodeUtils enumerateChildrenOfNode:node withBlock:^(id<LHNode> childNode, LHNodeModelState childModelState) {
            if (modelStateMask & LHNodeModelStateMaskWithState(childModelState)) {
                [tree addItem:childNode afterItemOrNil:node];
            }
        }];
    }
    
    for (id<LHNode> child in [tree nextItems:node]) {
        [self collectChildrenOfNode:child withModelStates:modelStateMask toTree:tree];
    }
}

@end
