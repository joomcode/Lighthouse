//
//  RTRNodeTree.m
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeTree.h"

@interface RTRNodeTree ()

@property (nonatomic, strong) NSMutableSet *nodes;
@property (nonatomic, strong) NSMapTable *nextNodes;
@property (nonatomic, strong) NSMapTable *previousNodes;

@end


@implementation RTRNodeTree

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _nodes = [[NSMutableSet alloc] init];
    _nextNodes = [NSMapTable strongToStrongObjectsMapTable];
    _previousNodes = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    RTRNodeTree *copy = [[[self class] allocWithZone:zone] init];
    
    copy.nodes = [self.nodes mutableCopy];
    copy.nextNodes = [self.nextNodes mutableCopy];
    copy.previousNodes = [self.previousNodes mutableCopy];
    
    return copy;
}

#pragma mark - Query

- (NSSet *)allNodes {
    return self.nodes;
}

- (id<RTRNode>)previousNode:(id<RTRNode>)node {
    return [self.previousNodes objectForKey:node];
}

- (NSOrderedSet *)nextNodes:(id<RTRNode>)node {
    return [self.nextNodes objectForKey:(node ?: (id)[NSNull null])];
}

- (NSOrderedSet *)pathToNode:(id<RTRNode>)node {
    NSMutableOrderedSet *path = [[NSMutableOrderedSet alloc] initWithObject:node];
    
    id<RTRNode> currentNode = node;
    
    while (currentNode) {
        [path insertObject:currentNode atIndex:0];
        currentNode = [self previousNode:currentNode];
    }
    
    return [path copy];
}

#pragma mark - Mutation

- (void)addNode:(id<RTRNode>)node afterNodeOrNil:(id<RTRNode>)previousNode {
    [self.nodes addObject:node];
    
    if (previousNode) {
        [self.previousNodes setObject:previousNode forKey:node];
    }
    
    NSMutableOrderedSet *nextNodes = [self.nextNodes objectForKey:(previousNode ?: (id)[NSNull null])];
    if (!nextNodes) {
        nextNodes = [[NSMutableOrderedSet alloc] init];
        [self.nextNodes setObject:nextNodes forKey:(previousNode ?: (id)[NSNull null])];
    }
    
    [nextNodes addObject:node];
}

- (void)addBranch:(NSArray *)nodes afterNodeOrNil:(id<RTRNode>)previousNode {
    [nodes enumerateObjectsUsingBlock:^(id<RTRNode> node, NSUInteger idx, BOOL *stop) {
        [self addNode:node afterNodeOrNil:(idx == 0 ? previousNode : nodes[idx - 1])];
    }];
}

@end
