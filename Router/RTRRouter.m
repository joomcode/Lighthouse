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
#import "RTRGraph.h"
#import "RTRCommand.h"
#import "RTRCommandRegistry.h"
#import "RTRTaskQueue.h"
#import "RTRCommandNodeUpdateTask.h"

NSString * const RTRRouterNodeStateDidUpdateNotification = @"com.pixty.router.nodeStateDidUpdate";


@interface RTRRouter () <RTRNodeDataStorageDelegate>

@property (nonatomic, strong) RTRGraph *graph;
@property (nonatomic, strong) RTRNodeDataStorage *nodeDataStorage;

@property (nonatomic, strong, readonly) RTRTaskQueue *commandQueue;

@property (nonatomic, strong, readonly) NSMapTable *dataByNode;

@property (nonatomic, strong) NSSet *initializedNodes;

@property (nonatomic, strong) NSMapTable *resolvedStateByNode;

@end


@implementation RTRRouter

#pragma mark - Config stuff

- (id<RTRNode>)rootNode {
    return self.graph.rootNode;
}

- (void)setRootNode:(id<RTRNode>)rootNode {
    self.graph = [[RTRGraph alloc] initWithRootNode:rootNode];
}

- (RTRNodeDataStorage *)nodeDataStorage {
    if (!_nodeDataStorage) {
        _nodeDataStorage = [[RTRNodeDataStorage alloc] init];
        _nodeDataStorage.delegate = self;
    }
    return _nodeDataStorage;
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
    RTRCommandNodeUpdateTask *task = [[RTRCommandNodeUpdateTask alloc] initWithNodeDataStorage:self.nodeDataStorage
                                                                           nodeContentProvider:self.nodeContentProvider
                                                                                         graph:self.graph
                                                                                      animated:animated];
    [task setCommand:command commandRegistry:self.commandRegistry];
    
    [self.commandQueue runTask:task];
}

#pragma mark - Node content state query

- (NSSet *)initializedNodes {
    return [self.nodeDataStorage initializedNodes];
}

- (RTRNodeState)stateForNode:(id<RTRNode>)node {
    return [self.nodeDataStorage resolvedStateForNode:node];
}

#pragma mark - RTRNodeDataStorageDelegate

- (void)nodeDataStorage:(RTRNodeDataStorage *)storage didChangeResolvedStateForNode:(id<RTRNode>)node {
    if ([self.nodeDataStorage hasDataForNode:node]) {
        id<RTRNodeContent> nodeContent = [self.nodeDataStorage dataForNode:node].content;
        
        if ([nodeContent respondsToSelector:@selector(stateDidChange:)]) {
            [nodeContent stateDidChange:[self.nodeDataStorage resolvedStateForNode:node]];
        }
    }
    
    // TODO
//    [self.delegate routerNodeStateDidUpdate:self];
//    [[NSNotificationCenter defaultCenter] postNotificationName:RTRRouterNodeStateDidUpdateNotification object:self];
}

@end
