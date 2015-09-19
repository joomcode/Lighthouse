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
        
        [pathTree addBranch:[pathToNode array] afterNodeOrNil:nil];
    }
    
    return pathTree;
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

@end
