//
//  LHGraph.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHGraph.h"
#import "LHNode.h"
#import "LHNodeTree.h"
#import "LHNodeChildrenState.h"

@interface LHGraph ()

@property (nonatomic, strong, readonly) LHNodeTree *tree;

@end


@implementation LHGraph

#pragma mark - Init

- (instancetype)initWithRootNode:(id<LHNode>)rootNode {
    self = [super init];
    if (!self) return nil;
    
    _rootNode = rootNode;
    
    _tree = [LHNodeTree treeWithDescendantsOfNode:_rootNode];
    
    return self;
}

#pragma mark - Public

- (NSOrderedSet<id<LHNode>> *)pathToNode:(id<LHNode>)node {
    return [self.tree pathToItem:node];
}

- (LHNodeTree *)pathsToNodes:(NSSet<id<LHNode>> *)nodes {
    LHNodeTree *pathTree = [[LHNodeTree alloc] init];
    
    for (id<LHNode> node in nodes) {
        NSOrderedSet *pathToNode = [self pathToNode:node];
        if (!pathToNode) {
            return nil;
        }
        
        [pathTree addBranch:[pathToNode array] afterItemOrNil:nil];
    }
    
    return pathTree;
}

- (LHNodeTree *)initializedNodesTree {
    return [LHNodeTree treeWithDescendantsOfNode:self.rootNode withStates:LHNodeStateMaskInitialized];
}

- (LHNodeTree *)activeNodesTree {
    return [LHNodeTree treeWithDescendantsOfNode:self.rootNode withStates:LHNodeStateMaskActive];
}

@end
