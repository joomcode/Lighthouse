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
#import "LHDebugDescription.h"

@interface LHStackNode () <LHDebugPrintable>

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
    
    id<LHNode> activeChild = [self activeChildForApplyingTarget:target
                                          toActiveChildrenStack:self.childrenState.stack
                                                          error:&error];
    
    if (error) {
        return LHNodeUpdateResultInvalid;
    }
    
    if (!activeChild) {
        return LHNodeUpdateResultDeactivation;
    }
    
    LHGraph<id<LHNode>> *graph = [self graphForChild:activeChild];
    if (!graph) {
        return LHNodeUpdateResultInvalid;
    }
    
    NSOrderedSet<id<LHNode>> *path = [graph pathFromNode:graph.rootNode toNode:activeChild visitingNodes:target.routeHint.nodes];
    NSAssert(path != nil, @"A path to the active node should exist");
    
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

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    return [self lh_descriptionWithIndent:indent block:^(NSMutableString *buffer, NSString *indentString, NSUInteger indent) {
        [buffer appendFormat:@"%@label = %@\n", indentString, self.label];
        [buffer appendFormat:@"%@childrenState = %@\n", indentString, [self.childrenState lh_descriptionWithIndent:indent]];
    }];
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
