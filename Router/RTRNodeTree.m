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

- (void)enumerateNodesWithBlock:(void (^)(id<RTRNode> node, NSInteger depth, BOOL *stop))enumerationBlock {
    [self enumerateNodesRecursivelyWithCurrentNode:nil currentDepth:0 enumerationBlock:enumerationBlock];
}

- (BOOL)enumerateNodesRecursivelyWithCurrentNode:(id<RTRNode>)currentNode
                                    currentDepth:(NSInteger)currentDepth
                                enumerationBlock:(void (^)(id<RTRNode> node, NSInteger depth, BOOL *stop))enumerationBlock {
    BOOL stop = NO;
    
    for (id<RTRNode> childNode in [self nextNodes:currentNode]) {
        enumerationBlock(childNode, currentDepth, &stop);
        
        if (stop) {
            break;
        }
        
        stop = [self enumerateNodesRecursivelyWithCurrentNode:childNode
                                                 currentDepth:currentDepth + 1
                                             enumerationBlock:enumerationBlock];
        
        if (stop) {
            break;
        }
    }
    
    return stop;
}

- (void)enumeratePathsToLeavesWithBlock:(void (^)(NSOrderedSet *path, BOOL *stop))enumerationBlock {
    BOOL stop = NO;
    
    for (id<RTRNode> node in self.nodes) {
        if ([self nextNodes:node].count == 0) {
            enumerationBlock([self pathToNode:node], &stop);
            
            if (stop) {
                break;
            }
        }
    }
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

- (void)addFork:(NSArray *)nodes afterNodeOrNil:(id<RTRNode>)previousNode {
    for (id<RTRNode> node in nodes) {
        [self addNode:node afterNodeOrNil:previousNode];
    }
}

@end
