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
#import "NSArray+LHUtils.h"

@interface LHStackNode () <LHDebugPrintable>

@end


@interface LHStackNode ()

@property (nonatomic, copy, readonly) NSArray<LHGraph<id<LHNode>> *> *graphs;

@property (nonatomic, strong) LHStackNodeChildrenState *childrenState;
@property (nonatomic, strong) NSArray<LHGraph<id<LHNode>> *> *activeGraphs;

@property (nonatomic, strong) NSMapTable<LHGraph<id<LHNode>> *, NSArray<id<LHNode>> *> *nodeStackByGraph;

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
        [self.nodeStackByGraph setObject:[NSArray arrayWithObject:graph.rootNode] forKey:graph];
    }
    self.activeGraphs = @[ self.graphs.firstObject ];
    
    [self doUpdateChildrenState];
}

- (LHNodeUpdateResult)updateChildrenState:(LHTarget *)target {
    if (target.activeNodes.count == 0 && target.inactiveNodes.count > 0 && ![self hasChildrenToDeactivateForTarget:target]) {
        return LHNodeUpdateResultNormal;
    }
    
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
    
    NSArray<id<LHNode>> *path = [self pathToNode:childToActivate inGraph:graph target:target];
    NSAssert(path != nil, @"A path to the target node should exist");
    
    LHLogInfo(@"Calculated path: %@", [LHDescriptionHelpers descriptionForNodePath:path]);
    
    [self.nodeStackByGraph setObject:path forKey:graph];
    
    [self activateGraph:graph];
    [self doUpdateChildrenState];
    
    return LHNodeUpdateResultNormal;
}

#pragma mark - Path Calculation

- (id<LHNode>)activeChildForApplyingTarget:(LHTarget *)target
                     toActiveChildrenStack:(NSArray<id<LHNode>> *)activeChildrenStack
                                     error:(BOOL *)error {
    if (target.activeNodes.count > 1) {
        if (error) {
            *error = YES;
        }
        return nil;
    }
    
    id<LHNode> childForTargetActiveNodes = target.activeNodes.anyObject;
    
    id<LHNode> childForTargetInactiveNodes = nil;
    
    NSMutableSet<id<LHNode>> *nodesToDeactivate = [target.inactiveNodes mutableCopy];
    BOOL inactiveNodeFound = NO;
    
    for (id<LHNode> node in [activeChildrenStack reverseObjectEnumerator]) {
        if ([nodesToDeactivate containsObject:node]) {
            [nodesToDeactivate removeObject:node];
            inactiveNodeFound = YES;
        } else if (inactiveNodeFound) {
            childForTargetInactiveNodes = node;
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

- (NSArray<id<LHNode>> *)pathToNode:(id<LHNode>)node inGraph:(LHGraph<id<LHNode>> *)graph target:(LHTarget *)target {
    NSArray<id<LHNode>> *path = nil;
    
    if (!target.routeHint) {
        if (target.activeNodes.count == 0 && target.inactiveNodes.count > 0) {
            path = [self calculatePathByDeactivatingNodesAfterNode:node inGraph:graph target:target];
        } else {
            path = [self calculatePathFromActiveNodeToNode:node inGraph:graph target:target];
        }
    } else if (target.routeHint.origin == LHRouteHintOriginActiveNode) {
        path = [self calculatePathFromActiveNodeToNode:node inGraph:graph target:target];
    } else {
        path = [self calculatePathFromRootToNode:node inGraph:graph target:target];
    }
    return [self bidirectionalTailFromPath:path inGraph:graph];
}

- (NSArray<id<LHNode>> *)calculatePathByDeactivatingNodesAfterNode:(id<LHNode>)node inGraph:(LHGraph<id<LHNode>> *)graph target:(LHTarget *)target {
    NSMutableSet<id<LHNode>> *nodesToDeactivate = [target.inactiveNodes mutableCopy];
    __block NSUInteger lastActiveNodeIndex = NSNotFound;

    [self.childrenState.stack enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<LHNode> obj, NSUInteger idx, BOOL *stop) {
        if ([nodesToDeactivate containsObject:obj]) {
            [nodesToDeactivate removeObject:obj];
        } else {
            lastActiveNodeIndex = idx;
            *stop = YES;
        }
    }];

    if (lastActiveNodeIndex == NSNotFound) {
        NSAssert(NO, @"`target.inactiveNodes` shouldn't require to deactivate all nodes in active children stack");
        return self.childrenState.stack;
    }

    id<LHNode> lastActiveNode = self.childrenState.stack[lastActiveNodeIndex];
    if (node != lastActiveNode) {
        NSAssert(NO, @"");
        return self.childrenState.stack;
    }
    
    return [self.childrenState.stack subarrayWithRange:(NSRange){ .length = lastActiveNodeIndex + 1 }];
}

- (NSArray<id<LHNode>> *)calculatePathFromActiveNodeToNode:(id<LHNode>)node
                                                   inGraph:(LHGraph<id<LHNode>> *)graph
                                                    target:(LHTarget *)target {

    id<LHNode> activeNode = self.childrenState.stack.lastObject;
    NSAssert(activeNode != nil, @"There should be an active node at this point");
    
    if (activeNode == node && target.routeHint.nodes.lastObject == node) {
        return [self.childrenState.stack arrayByAddingObject:node];
    }
    
    BOOL isDeactivatingActiveNode = [target.inactiveNodes containsObject:activeNode];
    if (isDeactivatingActiveNode && [self.childrenState.stack containsObject:node]) {
        return [self.childrenState.stack subarrayWithRange:NSMakeRange(0, self.childrenState.stack.count - 1)];
    }
        
    NSArray<id<LHNode>> *graphPath = [graph pathFromNode:activeNode toNode:node visitingNodes:target.routeHint.nodes].array;
    
    if (!target.routeHint.bidirectional) {
        return [self pathByConcatinatingPath:self.childrenState.stack withPath:graphPath];
    }
    
    NSArray<id<LHNode>> *commonSuffix = [self.childrenState.stack lh_commonSuffixWithArray:[graphPath reverseObjectEnumerator].allObjects];
    if (commonSuffix.count > 1) {
        NSArray<id<LHNode>> *remainingPart = [graphPath lh_arraySuffixWithLength:graphPath.count - commonSuffix.count];
        NSArray<id<LHNode>> *path = [self.childrenState.stack subarrayWithRange:NSMakeRange(0, self.childrenState.stack.count - commonSuffix.count + 1)];
        return [path arrayByAddingObjectsFromArray:remainingPart];
    } else {
        return [self pathByConcatinatingPath:self.childrenState.stack withPath:graphPath];
    }
}

- (NSArray<id<LHNode>> *)calculatePathFromRootToNode:(id<LHNode>)node
                                             inGraph:(LHGraph<id<LHNode>> *)graph
                                              target:(LHTarget *)target {
    return [graph pathFromNode:graph.rootNode toNode:node visitingNodes:target.routeHint.nodes].array;
}

- (NSArray<id<LHNode>> *)pathByConcatinatingPath:(NSArray<id<LHNode>> *)first withPath:(NSArray<id<LHNode>> *)second {
    NSMutableArray<id<LHNode>> *mutablePath = [first mutableCopy];
    
    if (first.count > 0 && second.count > 0) {
        [mutablePath removeLastObject];
    }
    [mutablePath addObjectsFromArray:second];
    return [mutablePath copy];
}

- (NSArray<id<LHNode>> *)bidirectionalTailFromPath:(NSArray<id<LHNode>> *)path inGraph:(LHGraph *)graph {
    NSMutableArray<id<LHNode>> *processedPath = [NSMutableArray array];
    NSArray<id<LHNode>> *reversedPath = [path reverseObjectEnumerator].allObjects;
    
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

#pragma mark - Graph Management

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

#pragma mark - Helpers

- (BOOL)hasChildrenToDeactivateForTarget:(LHTarget *)target {
    for (id<LHNode> node in target.inactiveNodes) {
        if ([self.childrenState.stack containsObject:node]) {
            return YES;
        }
    }
    return NO;
}

- (void)doUpdateChildrenState {
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    
    for (LHGraph<id<LHNode>> *graph in self.activeGraphs) {
        [stack addObjectsFromArray:[self.nodeStackByGraph objectForKey:graph]];
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
