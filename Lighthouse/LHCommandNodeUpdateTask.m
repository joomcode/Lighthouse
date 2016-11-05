	//
//  LHCommandNodeUpdateTask.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHCommandNodeUpdateTask.h"
#import "LHCommand.h"
#import "LHCommandRegistry.h"
#import "LHComponents.h"
#import "LHNode.h"
#import "LHTarget.h"
#import "LHNodeTree.h"
#import "LHRouteHint.h"

@implementation LHRouteHint (Helpers)

- (LHRouteHint *)filteredByParentNode:(id<LHNode>)parentNode {
    NSMutableOrderedSet<id<LHNode>> *nodes = [self.nodes mutableCopy];
    NSMutableOrderedSet<LHGraphEdge<id<LHNode>> *> *edges = [self.edges mutableCopy];
    
    for (id<LHNode> node in self.nodes) {
        if (![parentNode.allChildren containsObject:node]) {
            [nodes removeObject:node];
        }
    }
    for (LHGraphEdge<id<LHNode>> *edge in self.edges) {
        if (![parentNode.allChildren containsObject:edge.fromNode] ||
            ![parentNode.allChildren containsObject:edge.toNode]) {
            [edges removeObject:edge];
        }
    }
    return [LHRouteHint hintWithNodes:nodes edges:edges];
}

@end


@interface LHCommandNodeUpdateTask ()

@property (nonatomic, strong, readonly) id<LHCommand> command;

@end


@implementation LHCommandNodeUpdateTask

#pragma mark - Init

- (instancetype)initWithComponents:(LHComponents *)components animated:(BOOL)animated command:(id<LHCommand>)command {
    self = [super initWithComponents:components animated:animated];
    if (!self) return nil;
    
    _command = command;
    
    return self;
}

#pragma mark - LHNodeUpdateTask

- (void)updateNodesWithCompletion:(LHTaskCompletionBlock)completion {
    LHTarget *target = [self.components.commandRegistry targetForCommand:self.command];
    
    while (target) {
        NSMapTable *targetsByParent = [self splitTargetIntoTargetsByParent:target];
        
        NSMutableArray<id<LHNode>> *parentsToDeactivate = [NSMutableArray array];
        
        for (id<LHNode> parent in targetsByParent) {
            LHTarget *target = [targetsByParent objectForKey:parent];
            
            LHNodeUpdateResult result = [parent updateChildrenState:target];
            
            switch (result) {
                case LHNodeUpdateResultNormal:
                    // we're good
                    break;
                    
                case LHNodeUpdateResultDeactivation:
                    [parentsToDeactivate addObject:parent];
                    break;
                    
                case LHNodeUpdateResultInvalid:
                    [NSException raise:NSInternalInconsistencyException format:@"Attempted to update children of node %@ with target %@, got invalid state", parent, target];
                    break;
            }
        }
        
        target = parentsToDeactivate.count > 0 ? [LHTarget withInactiveNodes:parentsToDeactivate] : nil;
    }
    
    completion();
}

- (BOOL)shouldUpdateDriverForNode:(id<LHNode>)node {
    return YES;
}

#pragma mark - Stuff

- (NSMapTable<id<LHNode>, LHTarget *> *)splitTargetIntoTargetsByParent:(LHTarget *)jointTarget {
    NSMapTable<id<LHNode>, LHTarget *> *targetsByParent = [NSMapTable strongToStrongObjectsMapTable];
    
    for (id<LHNode> activeNode in jointTarget.activeNodes) {
        NSOrderedSet<id<LHNode>> *pathToNode = [self.components.tree pathToItem:activeNode];
        
        [pathToNode enumerateObjectsUsingBlock:^(id<LHNode> node, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                return;
            }
            
            id<LHNode> parent = pathToNode[idx - 1];
            
            LHTarget *target = [targetsByParent objectForKey:parent];
            
            if (target) {
                target = [[LHTarget alloc] initWithActiveNodes:[target.activeNodes setByAddingObject:node]
                                                 inactiveNodes:target.inactiveNodes
                                                     routeHint:[jointTarget.routeHint filteredByParentNode:parent]];
            } else {
                target = [LHTarget withActiveNode:node routeHint:[jointTarget.routeHint filteredByParentNode:parent]];
            }
            
            [targetsByParent setObject:target forKey:parent];
        }];
    }
    
    for (id<LHNode> inactiveNode in jointTarget.inactiveNodes) {
        NSOrderedSet<id<LHNode>> *pathToNode = [self.components.tree pathToItem:inactiveNode];
        
        id<LHNode> parent = pathToNode[pathToNode.count - 2];
        
        LHTarget *target = [targetsByParent objectForKey:parent];
        
        if (target) {
            target = [[LHTarget alloc] initWithActiveNodes:target.activeNodes
                                             inactiveNodes:[target.inactiveNodes setByAddingObject:inactiveNode]
                                                 routeHint:[jointTarget.routeHint filteredByParentNode:parent]];
        } else {
            target = [LHTarget withInactiveNode:inactiveNode routeHint:[jointTarget.routeHint filteredByParentNode:parent]];
        }
        
        [targetsByParent setObject:target forKey:parent];
    }
    
    return targetsByParent;
}

@end
