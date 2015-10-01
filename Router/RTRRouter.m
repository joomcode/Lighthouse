//
//  RTRRouter.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRRouter.h"
#import "RTRRouterDelegate.h"
#import "RTRNode.h"
#import "RTRNodeContent.h"
#import "RTRNodeDataStorage.h"
#import "RTRNodeData.h"
#import "RTRComponents.h"
#import "RTRGraph.h"
#import "RTRCommand.h"
#import "RTRCommandRegistry.h"
#import "RTRTaskQueue.h"
#import "RTRCommandNodeUpdateTask.h"

NSString * const RTRRouterNodeStateDidUpdateNotification = @"com.pixty.router.nodeStateDidUpdate";


@interface RTRRouter () <RTRNodeDataStorageDelegate>

@property (nonatomic, readonly) RTRComponents *components;

@property (nonatomic, strong, readonly) RTRTaskQueue *commandQueue;

@end


@implementation RTRRouter

#pragma mark - Components

@synthesize components = _components;

- (RTRComponents *)components {
    if (!_components) {
        _components = [[RTRComponents alloc] init];
        
        _components.nodeDataStorage = [[RTRNodeDataStorage alloc] init];
        _components.nodeDataStorage.delegate = self;
    }
    return _components;
}

- (id<RTRNodeContentProvider>)nodeContentProvider {
    return self.components.nodeContentProvider;
}

- (void)setNodeContentProvider:(id<RTRNodeContentProvider>)nodeContentProvider {
    self.components.nodeContentProvider = nodeContentProvider;
}

- (id<RTRCommandRegistry>)commandRegistry {
    return self.components.commandRegistry;
}

- (void)setCommandRegistry:(id<RTRCommandRegistry>)commandRegistry {
    self.components.commandRegistry = commandRegistry;
}

- (id<RTRNode>)rootNode {
    return self.components.graph.rootNode;
}

- (void)setRootNode:(id<RTRNode>)rootNode {
    self.components.graph = [[RTRGraph alloc] initWithRootNode:rootNode];
}

#pragma mark - Command execution

@synthesize commandQueue = _commandQueue;

- (RTRTaskQueue *)commandQueue {
    if (!_commandQueue) {
        _commandQueue = [[RTRTaskQueue alloc] init];
    }
    return _commandQueue;
}

- (void)executeCommand:(id<RTRCommand>)command animated:(BOOL)animated {
    RTRCommandNodeUpdateTask *task = [[RTRCommandNodeUpdateTask alloc] initWithComponents:self.components
                                                                                  command:command
                                                                                 animated:animated];
    
    [self.commandQueue runTask:task];
}

#pragma mark - Node content state query

- (NSSet *)initializedNodes {
    return [self.components.nodeDataStorage initializedNodes];
}

- (RTRNodeState)stateForNode:(id<RTRNode>)node {
    return [self.components.nodeDataStorage resolvedStateForNode:node];
}

#pragma mark - RTRNodeDataStorageDelegate

- (void)nodeDataStorage:(RTRNodeDataStorage *)storage didChangeResolvedStateForNode:(id<RTRNode>)node {
    if ([self.components.nodeDataStorage hasDataForNode:node]) {
        id<RTRNodeContent> nodeContent = [self.components.nodeDataStorage dataForNode:node].content;
        
        if ([nodeContent respondsToSelector:@selector(stateDidChange:)]) {
            [nodeContent stateDidChange:[self.components.nodeDataStorage resolvedStateForNode:node]];
        }
    }
    
    // TODO
//    [self.delegate routerNodeStateDidUpdate:self];
//    [[NSNotificationCenter defaultCenter] postNotificationName:RTRRouterNodeStateDidUpdateNotification object:self];
}

@end
