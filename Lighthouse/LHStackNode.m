//
//  LHStackNode.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHStackNode.h"
#import "LHGraph.h"
#import "LHStackNodeChildrenState.h"
#import "LHTarget.h"
#import "LHRouteHint.h"
#import "LHDebugPrintable.h"
#import "LHDescriptionHelpers.h"

@interface LHStackNode () <LHDebugPrintable>

@end


@interface LHStackNode ()

@property (nonatomic, copy, readonly) NSArray<LHGraph<id<LHNode>> *> *graphs;

@property (nonatomic, strong) LHStackNodeChildrenState *childrenState;
@property (nonatomic, strong) NSArray<LHGraph<id<LHNode>> *> *activeGraphs;

@property (nonatomic, strong) NSMapTable<LHGraph<id<LHNode>> *, NSOrderedSet<id<LHNode>> *> *nodeStackByGraph;

@end


@implementation LHStackNode

@synthesize label = _label;

#pragma mark - Init

- (instancetype)initWithSingleBranch:(NSArray<id<LHNode>> *)nodes label:(NSString *)label {
    NSParameterAssert(nodes.count > 0);
    
    LHMutableGraph *mutableGraph = [[LHMutableGraph alloc] init];
    
    [mutableGraph addNode:nodes.firstObject];
    mutableGraph.rootNode = nodes.firstObject;
    
    [nodes enumerateObjectsUsingBlock:^(id<LHNode> node, NSUInteger idx, BOOL *stop) {
        if (idx > 0) {
            id<LHNode> prevNode = [nodes objectAtIndex:idx - 1];
            [mutableGraph addEdgeFromNode:prevNode toNode:node];
        }
    }];
    return [self initWithGraph:[mutableGraph copy] label:label];
}

- (instancetype)initWithGraph:(LHGraph<id<LHNode>> *)graph label:(NSString *)label {
    NSParameterAssert(graph.nodes.count > 0);
    
    return [self initWithGraphs:@[ graph ] label:label];
}

- (instancetype)initWithGraphBlock:(void (^)(LHMutableGraph<id<LHNode>> *graph))graphBlock label:(NSString *)label {
    LHMutableGraph *mutableGraph = [[LHMutableGraph alloc] init];
    graphBlock(mutableGraph);
    
    return [self initWithGraph:[mutableGraph copy] label:label];
}

- (instancetype)initWithGraphs:(NSArray<LHGraph<id<LHNode>> *> *)graphs label:(NSString *)label {
    NSParameterAssert(graphs.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    _label = label;
    _graphs = [graphs copy];
    _allChildren = [self collectAllChildrenFromGraphs:_graphs];
    
    [self resetChildrenState];
    
    return self;    
}

- (NSSet *)collectAllChildrenFromGraphs:(NSArray<LHGraph<id<LHNode>> *> *)graphs {
    NSMutableSet<id<LHNode>> *allChildren = [[NSMutableSet alloc] init];
    for (LHGraph<id<LHNode>> *graph in graphs) {
        [allChildren unionSet:graph.nodes];
    }
    return allChildren;
}

#pragma mark - LHNode

@synthesize allChildren = _allChildren;

- (void)resetChildrenState {
    self.nodeStackByGraph = [NSMapTable strongToStrongObjectsMapTable];
    
    for (LHGraph<id<LHNode>> *graph in self.graphs) {
        [self.nodeStackByGraph setObject:[NSOrderedSet orderedSetWithObject:graph.rootNode] forKey:graph];
    }
    self.activeGraphs = @[ self.graphs.firstObject ];
    
    [self doUpdateChildrenState];
}

- (LHNodeUpdateResult)updateChildrenState:(LHTarget *)target {
    BOOL error = NO;
    
    id<LHNode> childToActivate = [self activeChildForApplyingTarget:target
                                              toActiveChildrenStack:self.childrenState.stack
                                                              error:&error];
    
    if (error) {
        return LHNodeUpdateResultInvalid;
    }
    
    if (!childToActivate) {
        return LHNodeUpdateResultDeactivation;
    }
    
    LHGraph<id<LHNode>> *graph = [self graphForChild:childToActivate];
    if (!graph) {
        return LHNodeUpdateResultInvalid;
    }
    
    NSOrderedSet<id<LHNode>> *path = [self pathToNode:childToActivate inGraph:graph usingHint:target.routeHint];
    NSAssert(path != nil, @"A path to the target node should exist");
    
//    NSLog(@"Calculated path: %@", [LHDescriptionHelpers descriptionForNodePath:path]);
    
    [self.nodeStackByGraph setObject:path forKey:graph];
    
    [self activateGraph:graph];
    [self doUpdateChildrenState];
    
    return LHNodeUpdateResultNormal;
}

#pragma mark - Stuff

- (id<LHNode>)activeChildForApplyingTarget:(LHTarget *)target
                     toActiveChildrenStack:(NSOrderedSet<id<LHNode>> *)activeChildrenStack
                                     error:(BOOL *)error {
    if (target.activeNodes.count > 1) {
        if (error) {
            *error = YES;
        }
        return nil;
    }
    
    id<LHNode> childForTargetActiveNodes = target.activeNodes.anyObject;
    
    id<LHNode> childForTargetInactiveNodes = nil;
    
    for (id<LHNode> node in [activeChildrenStack reverseObjectEnumerator]) {
        if (![target.inactiveNodes containsObject:node]) {
            if (node != activeChildrenStack.lastObject) {
                childForTargetInactiveNodes = node;
            }
            break;
        }
    }
    
    if (childForTargetActiveNodes && childForTargetInactiveNodes && childForTargetActiveNodes != childForTargetInactiveNodes) {
        if (error) {
            *error = YES;
        }
        return nil;
    }
    
    return childForTargetActiveNodes ?: childForTargetInactiveNodes;
}

- (NSOrderedSet<id<LHNode>> *)pathToNode:(id<LHNode>)node inGraph:(LHGraph<id<LHNode>> *)graph usingHint:(LHRouteHint *)routeHint {
    id<LHNode> activeChild = self.childrenState.stack.lastObject;
    NSAssert(activeChild != nil, @"There should be an active node at this point");
    
    NSOrderedSet<id<LHNode>> *path = nil;
    
    if (!routeHint || routeHint.origin == LHRouteHintOriginActiveNode) {
        if (![self.childrenState.stack containsObject:node]) {
            path = [graph pathFromNode:activeChild toNode:node visitingNodes:routeHint.nodes];
            path = [self pathByConcatinatingPath:self.childrenState.stack withPath:path];
        } else {
            path = [self pathByCuttingPath:self.childrenState.stack toNode:node];
        }
    } else {
        path = [graph pathFromNode:graph.rootNode toNode:node visitingNodes:routeHint.nodes];
    }
    return [self bidirectionalTailFromPath:path inGraph:graph];
}

- (NSOrderedSet<id<LHNode>> *)pathByConcatinatingPath:(NSOrderedSet<id<LHNode>> *)first withPath:(NSOrderedSet<id<LHNode>> *)second {
    NSMutableOrderedSet<id<LHNode>> *mutablePath = [first mutableCopy];
    [mutablePath unionOrderedSet:second];
    return [mutablePath copy];
}

- (NSOrderedSet<id<LHNode>> *)pathByCuttingPath:(NSOrderedSet<id<LHNode>> *)path toNode:(id<LHNode>)cuttingNode {
    NSMutableOrderedSet<id<LHNode>> *mutablePath = [NSMutableOrderedSet orderedSet];
    for (id<LHNode> node in path) {
        [mutablePath addObject:node];
        if (node == cuttingNode) {
            break;
        }
    }
    return [mutablePath copy];
}

- (NSOrderedSet<id<LHNode>> *)bidirectionalTailFromPath:(NSOrderedSet<id<LHNode>> *)path inGraph:(LHGraph *)graph {
    NSMutableOrderedSet<id<LHNode>> *processedPath = [NSMutableOrderedSet orderedSet];
    NSOrderedSet<id<LHNode>> *reversedPath = [path reverseObjectEnumerator].allObjects;
    
    [reversedPath enumerateObjectsUsingBlock:^(id<LHNode> node, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [processedPath addObject:node];
            return;
        }
        id<LHNode> prevNode = [reversedPath objectAtIndex:idx - 1];
        if ([graph hasEdgeFromNode:prevNode toNode:node]) {
            [processedPath insertObject:node atIndex:0];
        } else {
            *stop = YES;
        }
    }];
    return [processedPath copy];
}

- (LHGraph<id<LHNode>> *)graphForChild:(id<LHNode>)child {
    for (LHGraph<id<LHNode>> *graph in self.graphs) {
        if ([graph.nodes containsObject:child]) {
            return graph;
        }
    }
    
    return nil;
}

- (void)activateGraph:(LHGraph<id<LHNode>> *)graph {
    NSInteger activeGraphsIndex = [self.activeGraphs indexOfObject:graph];
    
    if (activeGraphsIndex != NSNotFound) {
        self.activeGraphs = [self.activeGraphs subarrayWithRange:NSMakeRange(0, activeGraphsIndex + 1)];
    } else {
        self.activeGraphs = [self.activeGraphs arrayByAddingObject:graph];
    }
}

- (void)doUpdateChildrenState {
    NSMutableOrderedSet *stack = [[NSMutableOrderedSet alloc] init];
    
    for (LHGraph<id<LHNode>> *graph in self.activeGraphs) {
        [stack unionOrderedSet:[self.nodeStackByGraph objectForKey:graph]];
    }
    
    self.childrenState = [[LHStackNodeChildrenState alloc] initWithStack:stack];
}

#pragma mark - LHDebugPrintable

- (NSDictionary<NSString *,id> *)lh_debugProperties {
    return @{ @"label": self.label ?: [NSNull null], @"childrenState": self.childrenState };
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
