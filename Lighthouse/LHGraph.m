//
//  LHGraph.m
//  Lighthouse
//
//  Created by Makarov Yury on 03/11/2016.
//  Copyright © 2016 Joom. All rights reserved.
//

#import "LHGraph.h"
#import "LHDebugPrintable.h"
#import "NSMapTable+LHUtils.h"

@interface LHGraph () <LHDebugPrintable> {
    
@protected
    id _rootNode;
    NSMapTable<id, NSCountedSet<LHGraphEdge *> *> *_outgoingEdgesByNode;
    NSSet<LHGraphEdge *> *_edges;
}

@property (nonatomic, strong, readonly) NSMapTable<id, NSCountedSet<LHGraphEdge *> *> *outgoingEdgesByNode;

@end


@implementation LHGraph

#pragma mark - Init

- (instancetype)initWithRootNode:(id)rootNode nodes:(NSSet *)nodes edges:(NSSet *)edges {
    self = [super init];
    if (self) {
        if (rootNode && nodes) {
            NSParameterAssert([nodes containsObject:rootNode]);
        } else if (rootNode) {
            nodes = [NSSet setWithObject:rootNode];
        } else if (nodes) {
            rootNode = nodes.anyObject;
        }
        _rootNode = rootNode;
        _edges = edges ?: [NSSet set];
        
        _outgoingEdgesByNode = [self calculateOutgoingEdgesByNodeForNodes:nodes edges:edges];
    }
    return self;
}

- (instancetype)init {
    return [self initWithRootNode:nil nodes:nil edges:nil];
}

#pragma mark - Public

- (NSSet *)nodes {
    return [NSSet setWithArray:self.outgoingEdgesByNode.lh_allKeys];
}

- (NSOrderedSet *)pathFromNode:(id)source toNode:(id)target visitingNodes:(NSOrderedSet *)nodes {
    NSMutableOrderedSet *path = [NSMutableOrderedSet orderedSet];
    
    NSMutableOrderedSet *passNodes = nodes ? [nodes mutableCopy] : [NSMutableOrderedSet orderedSet];
    [passNodes removeObject:source];
    [passNodes addObject:target];
    
    id prevNode = source;
    
    for (id node in passNodes) {
        NSOrderedSet *partialPath = [self pathFromNode:prevNode toNode:node];
        if (!partialPath) {
            return nil;
        }
        [path unionOrderedSet:partialPath];
        prevNode = node;
    }
    return [path copy];
}

- (NSOrderedSet *)pathFromNode:(id)source toNode:(id)target {
    if (source == target) {
        return [NSOrderedSet orderedSetWithObject:target];
    }
    
    NSMutableOrderedSet *path = [NSMutableOrderedSet orderedSet];
    NSMutableArray *nodeQueue = [NSMutableArray array];
    NSMutableSet *visitedNodes = [NSMutableSet set];
    NSMapTable *previousNodes = [NSMapTable strongToStrongObjectsMapTable];
    
    [nodeQueue addObject:source];
    [visitedNodes addObject:source];
    
    BOOL found = NO;
    
    while (nodeQueue.count > 0) {
        id node = [nodeQueue objectAtIndex:0];
        [nodeQueue removeObjectAtIndex:0];
        
        if (node == target) {
            found = YES;
            break;
        }
        for (LHGraphEdge *edge in [self.outgoingEdgesByNode objectForKey:node]) {
            if (![visitedNodes containsObject:edge.toNode]) {
                [visitedNodes addObject:edge.toNode];
                
                [nodeQueue addObject:edge.toNode];
                [previousNodes setObject:node forKey:edge.toNode];
            }
        }
    }
    if (!found) {
        return nil;
    }
    
    id nextNode = target;
    while (nextNode) {
        [path insertObject:nextNode atIndex:0];
        nextNode = [previousNodes objectForKey:nextNode];
    }
    return [path copy];
}

- (NSSet<LHGraphEdge *> *)outgoingEdgesForNode:(id)node {
    return [[self.outgoingEdgesByNode objectForKey:node] copy];
}

- (BOOL)hasEdgeFromNode:(id)source toNode:(id)target {
    for (LHGraphEdge *edge in [self outgoingEdgesForNode:source]) {
        if (edge.toNode == target) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return [[LHGraph alloc] initWithRootNode:self.rootNode nodes:self.nodes edges:self.edges];
}

#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[LHMutableGraph alloc] initWithRootNode:self.rootNode nodes:self.nodes edges:self.edges];
}

#pragma mark - LHDebugPrintable

- (NSDictionary<NSString *,id> *)lh_debugProperties {
    return @{ @"rootNode": self.rootNode ?: [NSNull null], @"nodes": self.nodes, @"edges": self.edges };
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

#pragma mark - Private

- (NSMapTable<id, NSCountedSet<LHGraphEdge *> *> *)calculateOutgoingEdgesByNodeForNodes:(NSSet *)nodes edges:(NSSet *)edges {
    NSMapTable<id, NSCountedSet<LHGraphEdge *> *> *outgoingEdges = [NSMapTable strongToStrongObjectsMapTable];
    
    for (id node in nodes) {
        [outgoingEdges setObject:[NSCountedSet set] forKey:node];
    }
    for (LHGraphEdge *edge in edges) {
        NSCountedSet *edgeBag = [outgoingEdges objectForKey:edge.fromNode];
        [edgeBag addObject:edge];
    }
    return [outgoingEdges copy];
}

@end


@interface LHMutableGraph ()

@property (nonatomic, copy, readonly) NSMutableSet<LHGraphEdge *> *edges;

@end


@implementation LHMutableGraph

@dynamic rootNode;
@dynamic edges;

- (instancetype)initWithRootNode:(id)rootNode nodes:(NSSet *)nodes edges:(NSSet *)edges {
    self = [super initWithRootNode:rootNode nodes:nodes edges:edges];
    if (self) {
        _edges = [_edges mutableCopy];
    }
    return self;
}

- (void)addNode:(id)node {
    if ([self.outgoingEdgesByNode objectForKey:node]) {
        return;
    }
    [self.outgoingEdgesByNode setObject:[NSCountedSet set] forKey:node];
}

- (void)removeNode:(id)node {
    NSCountedSet<LHGraphEdge *> *edgeBag = [self.outgoingEdgesByNode objectForKey:node];
    for (LHGraphEdge *edge in edgeBag) {
        [self.edges removeObject:edge];
    }
    [self.outgoingEdgesByNode removeObjectForKey:node];
}

- (void)setRootNode:(id)rootNode {
    _rootNode = rootNode;
    
    [self addNode:rootNode];
}

- (LHGraphEdge *)addEdgeFromNode:(id)fromNode toNode:(id)toNode label:(NSString *)label {
    [self addNode:fromNode];
    [self addNode:toNode];
    
    LHGraphEdge *edge = [[LHGraphEdge alloc] initWithFromNode:fromNode toNode:toNode label:label];
    
    NSCountedSet<LHGraphEdge *> *edgeBag = [self.outgoingEdgesByNode objectForKey:fromNode];
    [edgeBag addObject:edge];
    
    [self.edges addObject:edge];
    
    return edge;
}

- (LHGraphEdge *)addEdgeFromNode:(id)fromNode toNode:(id)toNode {
    return [self addEdgeFromNode:fromNode toNode:toNode label:nil];
}

- (NSOrderedSet<LHGraphEdge *> *)addEdgesFromNode:(id)fromNode toNodes:(NSArray *)toNodes {
    NSMutableOrderedSet<LHGraphEdge *> *edges = [NSMutableOrderedSet orderedSet];
    
    for (id node in toNodes) {
        [edges addObject:[self addEdgeFromNode:fromNode toNode:node]];
    }
    return [edges copy];
}

- (NSOrderedSet<LHGraphEdge *> *)addBidirectionalEdgeFromNode:(id)fromNode toNode:(id)toNode {
    return [NSOrderedSet orderedSetWithArray:@[ [self addEdgeFromNode:fromNode toNode:toNode],
                                                [self addEdgeFromNode:toNode toNode:fromNode] ]];
}

- (NSOrderedSet<LHGraphEdge *> *)addBidirectionalEdgesFromNode:(id)fromNode toNodes:(NSArray *)toNodes {
    NSMutableOrderedSet<LHGraphEdge *> *edges = [NSMutableOrderedSet orderedSet];
    
    for (id node in toNodes) {
        [edges unionOrderedSet:[self addBidirectionalEdgeFromNode:fromNode toNode:node]];
    }
    return [edges copy];
}

- (void)removeEdge:(LHGraphEdge *)edge {
    [self.edges removeObject:edge];
    
    NSCountedSet<LHGraphEdge *> *edgeBag = [self.outgoingEdgesByNode objectForKey:edge.fromNode];
    [edgeBag removeObject:edge];
}

@end
