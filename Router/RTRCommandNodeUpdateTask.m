//
//  RTRCommandNodeUpdateTask.m
//  Router
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRCommandNodeUpdateTask.h"
#import "RTRCommand.h"
#import "RTRCommandRegistry.h"
#import "RTRComponents.h"
#import "RTRNode.h"
#import "RTRTargetNodes.h"
#import "RTRGraph.h"

@interface RTRCommandNodeUpdateTask ()

@property (nonatomic, readonly) id<RTRCommand> command;

@end


@implementation RTRCommandNodeUpdateTask

#pragma mark - Init

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated {
    return [self initWithComponents:components command:nil animated:animated];
}

- (instancetype)initWithComponents:(RTRComponents *)components command:(id<RTRCommand>)command animated:(BOOL)animated {
    NSParameterAssert(command != nil);
    
    self = [super initWithComponents:components animated:animated];
    if (!self) return nil;
    
    _command = command;
    
    return self;
}

#pragma mark - RTRNodeUpdateTask

- (void)updateNodes {
    NSMapTable *targetNodesByParent = [self targetNodesByParent];
    
    for (id<RTRNode> parent in targetNodesByParent) {
        RTRTargetNodes *targetNodes = [targetNodesByParent objectForKey:parent];
        
        if (![parent updateChildrenState:targetNodes]) {
            NSAssert(NO, @""); // TODO
        }
    }
}

- (BOOL)shouldUpdateContentForNode:(id<RTRNode>)node {
    return YES;
}

#pragma mark - Stuff

- (NSMapTable *)targetNodesByParent {
    NSMapTable *targetNodesByParent = [NSMapTable strongToStrongObjectsMapTable];
    
    RTRTargetNodes *commandTargetNodes = [self.components.commandRegistry targetNodesForCommand:self.command];
    
    for (id<RTRNode> activeNode in commandTargetNodes.activeNodes) {
        NSOrderedSet *pathToNode = [self.components.graph pathToNode:activeNode];
        
        [pathToNode enumerateObjectsUsingBlock:^(id<RTRNode> node, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                return;
            }
            
            id<RTRNode> parent = pathToNode[idx - 1];
            
            RTRTargetNodes *targetNodes = [targetNodesByParent objectForKey:parent];
            
            if (targetNodes) {
                targetNodes = [[RTRTargetNodes alloc] initWithActiveNodes:[targetNodes.activeNodes setByAddingObject:node]
                                                            inactiveNodes:targetNodes.inactiveNodes];
            } else {
                targetNodes = [[RTRTargetNodes alloc] initWithActiveNodes:[NSSet setWithObject:node] inactiveNodes:nil];
            }
            
            [targetNodesByParent setObject:targetNodes forKey:parent];
        }];
    }
    
    for (id<RTRNode> inactiveNode in commandTargetNodes.inactiveNodes) {
        NSOrderedSet *pathToNode = [self.components.graph pathToNode:inactiveNode];
        
        id<RTRNode> parent = pathToNode[pathToNode.count - 2];
        
        RTRTargetNodes *targetNodes = [targetNodesByParent objectForKey:parent];
        
        if (targetNodes) {
            targetNodes = [[RTRTargetNodes alloc] initWithActiveNodes:targetNodes.activeNodes
                                                        inactiveNodes:[targetNodes.inactiveNodes setByAddingObject:inactiveNode]];
        } else {
            targetNodes = [[RTRTargetNodes alloc] initWithActiveNodes:nil inactiveNodes:[NSSet setWithObject:inactiveNode]];
        }
        
        [targetNodesByParent setObject:targetNodes forKey:parent];
    }
    
    return targetNodesByParent;
}

@end
