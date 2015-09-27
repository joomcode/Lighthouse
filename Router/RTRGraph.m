//
//  RTRGraph.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRGraph.h"
#import "RTRNode.h"
#import "RTRNodeTree.h"
#import "RTRNodeChildrenState.h"

@implementation RTRGraph

#pragma mark - Init

- (instancetype)init {
    return [self initWithRootNode:nil];
}

- (instancetype)initWithRootNode:(id<RTRNode>)rootNode {
    NSParameterAssert(rootNode != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _rootNode = rootNode;
    
    return self;
}

#pragma mark - Public

- (NSOrderedSet *)pathToNode:(id<RTRNode>)node {
    NSMutableOrderedSet *currentPath = [[NSMutableOrderedSet alloc] initWithObject:self.rootNode];
    
    return [self searchForNodeRecursively:node currentPath:currentPath] ? currentPath : nil;
}

- (RTRNodeTree *)pathsToNodes:(NSSet *)nodes {
    RTRNodeTree *pathTree = [[RTRNodeTree alloc] init];
    
    for (id<RTRNode> node in nodes) {
        NSOrderedSet *pathToNode = [self pathToNode:node];
        if (!pathToNode) {
            return nil;
        }
        
        [pathTree addBranch:[pathToNode array] afterItemOrNil:nil];
    }
    
    return pathTree;
}

- (RTRNodeTree *)initializedNodesTree {
    RTRNodeTree *tree = [[RTRNodeTree alloc] init];
    [tree addItem:self.rootNode afterItemOrNil:nil];
    
    [self collectInitializedNodesRecursively:self.rootNode currentTree:tree];
    
    return tree;
}

- (RTRNodeTree *)activeNodesTree {
    RTRNodeTree *tree = [[RTRNodeTree alloc] init];
    [tree addItem:self.rootNode afterItemOrNil:nil];
    
    [self collectActiveNodesRecursively:self.rootNode currentTree:tree];
    
    return tree;
}

#pragma mark - Private

- (BOOL)searchForNodeRecursively:(id<RTRNode>)node currentPath:(NSMutableOrderedSet *)currentPath {
    id<RTRNode> currentNode = currentPath.lastObject;
    
    if ([currentNode isEqual:node]) {
        return YES;
    }
    
    for (id<RTRNode> child in [currentNode allChildren]) {
        [currentPath addObject:child];
        
        if ([self searchForNodeRecursively:node currentPath:currentPath]) {
            return YES;
        } else {
            [currentPath removeObjectAtIndex:currentPath.count - 1];
        }
    }
    
    return NO;
}

- (void)collectInitializedNodesRecursively:(id<RTRNode>)node currentTree:(RTRNodeTree *)currentTree {
    [currentTree addFork:[node.childrenState.initializedChildren array] afterItemOrNil:node];
    
    for (id<RTRNode> childNode in node.childrenState.initializedChildren) {
        [self collectInitializedNodesRecursively:childNode currentTree:currentTree];
    }
}

- (void)collectActiveNodesRecursively:(id<RTRNode>)node currentTree:(RTRNodeTree *)currentTree {
    [currentTree addFork:[node.childrenState.activeChildren array] afterItemOrNil:node];
    
    for (id<RTRNode> childNode in node.childrenState.activeChildren) {
        [self collectInitializedNodesRecursively:childNode currentTree:currentTree];
    }
}

@end
