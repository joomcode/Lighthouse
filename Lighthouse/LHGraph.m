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

@implementation LHGraph

#pragma mark - Init

- (instancetype)initWithRootNode:(id<LHNode>)rootNode {
    self = [super init];
    if (!self) return nil;
    
    _rootNode = rootNode;
    
    return self;
}

#pragma mark - Public

- (NSOrderedSet<id<LHNode>> *)pathToNode:(id<LHNode>)node {
    NSMutableOrderedSet<id<LHNode>> *currentPath = [[NSMutableOrderedSet alloc] initWithObject:self.rootNode];
    
    return [self searchForNodeRecursively:node currentPath:currentPath] ? currentPath : nil;
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
    LHNodeTree *tree = [[LHNodeTree alloc] init];
    [tree addItem:self.rootNode afterItemOrNil:nil];
    
    [self collectInitializedNodesRecursively:self.rootNode currentTree:tree];
    
    return tree;
}

- (LHNodeTree *)activeNodesTree {
    LHNodeTree *tree = [[LHNodeTree alloc] init];
    [tree addItem:self.rootNode afterItemOrNil:nil];
    
    [self collectActiveNodesRecursively:self.rootNode currentTree:tree];
    
    return tree;
}

#pragma mark - Private

- (BOOL)searchForNodeRecursively:(id<LHNode>)node currentPath:(NSMutableOrderedSet<id<LHNode>> *)currentPath {
    id<LHNode> currentNode = currentPath.lastObject;
    
    if ([currentNode isEqual:node]) {
        return YES;
    }
    
    for (id<LHNode> child in [currentNode allChildren]) {
        [currentPath addObject:child];
        
        if ([self searchForNodeRecursively:node currentPath:currentPath]) {
            return YES;
        } else {
            [currentPath removeObjectAtIndex:currentPath.count - 1];
        }
    }
    
    return NO;
}

- (void)collectInitializedNodesRecursively:(id<LHNode>)node currentTree:(LHNodeTree *)currentTree {
    [currentTree addFork:[node.childrenState.initializedChildren array] afterItemOrNil:node];
    
    for (id<LHNode> childNode in node.childrenState.initializedChildren) {
        [self collectInitializedNodesRecursively:childNode currentTree:currentTree];
    }
}

- (void)collectActiveNodesRecursively:(id<LHNode>)node currentTree:(LHNodeTree *)currentTree {
    [currentTree addFork:[node.childrenState.activeChildren allObjects] afterItemOrNil:node];
    
    for (id<LHNode> childNode in node.childrenState.activeChildren) {
        [self collectInitializedNodesRecursively:childNode currentTree:currentTree];
    }
}

@end
