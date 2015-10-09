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
#import "RTRTarget.h"
#import "RTRGraph.h"

@interface RTRCommandNodeUpdateTask ()

@property (nonatomic, readonly) id<RTRCommand> command;

@end


@implementation RTRCommandNodeUpdateTask

#pragma mark - Init

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated {
    return [self initWithComponents:components animated:animated command:nil];
}

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated command:(id<RTRCommand>)command {
    NSParameterAssert(command != nil);
    
    self = [super initWithComponents:components animated:animated];
    if (!self) return nil;
    
    _command = command;
    
    return self;
}

#pragma mark - RTRNodeUpdateTask

- (void)updateNodes {
    NSMapTable *targetsByParent = [self calculateTargetsByParent];
    
    for (id<RTRNode> parent in targetsByParent) {
        id<RTRTarget> target = [targetsByParent objectForKey:parent];
        
        if (![parent updateChildrenState:target]) {
            NSAssert(NO, @""); // TODO
        }
    }
}

- (BOOL)shouldUpdateDriverForNode:(id<RTRNode>)node {
    return YES;
}

#pragma mark - Stuff

- (NSMapTable *)calculateTargetsByParent {
    NSMapTable *targetsByParent = [NSMapTable strongToStrongObjectsMapTable];
    
    id<RTRTarget> commandTarget = [self.components.commandRegistry targetForCommand:self.command];
    
    for (id<RTRNode> activeNode in commandTarget.activeNodes) {
        NSOrderedSet *pathToNode = [self.components.graph pathToNode:activeNode];
        
        [pathToNode enumerateObjectsUsingBlock:^(id<RTRNode> node, NSUInteger idx, BOOL *stop) {
            if (idx == 0) {
                return;
            }
            
            id<RTRNode> parent = pathToNode[idx - 1];
            
            id<RTRTarget> target = [targetsByParent objectForKey:parent];
            
            if (target) {
                target = [[RTRTarget alloc] initWithActiveNodes:[target.activeNodes setByAddingObject:node]
                                                  inactiveNodes:target.inactiveNodes];
            } else {
                target = [RTRTarget withActiveNode:node];
            }
            
            [targetsByParent setObject:target forKey:parent];
        }];
    }
    
    for (id<RTRNode> inactiveNode in commandTarget.inactiveNodes) {
        NSOrderedSet *pathToNode = [self.components.graph pathToNode:inactiveNode];
        
        id<RTRNode> parent = pathToNode[pathToNode.count - 2];
        
        id<RTRTarget> target = [targetsByParent objectForKey:parent];
        
        if (target) {
            target = [[RTRTarget alloc] initWithActiveNodes:target.activeNodes
                                              inactiveNodes:[target.inactiveNodes setByAddingObject:inactiveNode]];
        } else {
            target = [RTRTarget withInactiveNode:inactiveNode];
        }
        
        [targetsByParent setObject:target forKey:parent];
    }
    
    return targetsByParent;
}

@end
