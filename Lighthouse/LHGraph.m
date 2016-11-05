//
//  LHGraph.m
//  Lighthouse
//
//  Created by Makarov Yury on 03/11/2016.
//  Copyright © 2016 Joom. All rights reserved.
//

#import "LHGraph.h"
#import "NSMapTable+LHUtils.h"
#import "LHDebugDescription.h"

@interface LHGraph () {
    
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
    return [NSSet setWithArray:self.outgoingEdgesByNode.allKeys];
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
        for (LHGraphEdge *edge in self.outgoingEdgesByNode[node]) {
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
    return [self.outgoingEdgesByNode[node] copy];
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

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    return [self lh_descriptionWithIndent:indent block:^(NSMutableString *buffer, NSString *indentString, NSUInteger indent) {
        [buffer appendFormat:@"%@rootNode = %@\n", indentString, [self.rootNode lh_descriptionWithIndent:indent]];
        [buffer appendFormat:@"%@nodes = %@\n", indentString, [self.nodes lh_descriptionWithIndent:indent]];
        [buffer appendFormat:@"%@edges = %@\n", indentString, [self.edges lh_descriptionWithIndent:indent]];
    }];
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

#pragma mark - Private

- (NSMapTable<id, NSCountedSet<LHGraphEdge *> *> *)calculateOutgoingEdgesByNodeForNodes:(NSSet *)nodes edges:(NSSet *)edges {
    NSMapTable<id, NSCountedSet<LHGraphEdge *> *> *outgoingEdges = [NSMapTable strongToStrongObjectsMapTable];
    
    for (id node in nodes) {
        outgoingEdges[node] = [NSCountedSet set];
    }
    for (LHGraphEdge *edge in edges) {
        [outgoingEdges[edge.fromNode] addObject:edge];
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
    if (self.outgoingEdgesByNode[node]) {
        return;
    }
    self.outgoingEdgesByNode[node] = [NSCountedSet set];
}

- (void)removeNode:(id)node {
    for (LHGraphEdge *edge in self.outgoingEdgesByNode[node]) {
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
    
    [self.outgoingEdgesByNode[fromNode] addObject:edge];
    [self.edges addObject:edge];
    
    return edge;
}

- (LHGraphEdge *)addEdgeFromNode:(id)fromNode toNode:(id)toNode {
    return [self addEdgeFromNode:fromNode toNode:toNode label:nil];
}

- (void)removeEdge:(LHGraphEdge *)edge {
    [self.edges removeObject:edge];
    [self.outgoingEdgesByNode[edge.fromNode] removeObject:edge];
}

@end
