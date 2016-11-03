//
//  LHGraph.m
//  Lighthouse
//
//  Created by Makarov Yury on 03/11/2016.
//  Copyright © 2016 Joom. All rights reserved.
//

#import "LHGraph.h"

@implementation LHGraph

- (instancetype)initWithRootNode:(id)rootNode edges:(NSArray *)edges {
    self = [super init];
    if (self) {
        _rootNode = rootNode;
        _nodes = rootNode ? [NSSet setWithObject:rootNode] : [NSSet set];
        _edges = edges ?: @[];
    }
    return self;
}

- (instancetype)init {
    return [self initWithRootNode:nil edges:nil];
}

- (NSOrderedSet *)pathFromNode:(id)source toNode:(id)target visitingNodes:(NSArray *)nodes visitingEdges:(NSArray *)edges {
    return nil;
}

- (NSOrderedSet *)pathFromNode:(id)source toNode:(id)target {
    return [self pathFromNode:source toNode:target visitingNodes:nil visitingEdges:nil];
}

- (BOOL)containsNode:(id)node {
    return NO;
}

@end

@implementation LHMutableGraph

- (LHGraphEdge *)addEdgeFromNode:(id)fromNode toNode:(id)toNode label:(NSString *)label {
    return nil;
}

- (LHGraphEdge *)addEdgeFromNode:(id)fromNode toNode:(id)toNode {
    return nil;
}

- (void)removeNode:(id)node {
    
}

- (void)removeEdge:(LHGraphEdge *)edge {
    
}

@end
