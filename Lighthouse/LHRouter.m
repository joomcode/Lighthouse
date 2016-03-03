//
//  LHRouter.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHRouter.h"
#import "LHRouterDelegate.h"
#import "LHNode.h"
#import "LHDriver.h"
#import "LHDriverFactory.h"
#import "LHDriverTools.h"
#import "LHNodeDataStorage.h"
#import "LHNodeData.h"
#import "LHComponents.h"
#import "LHGraph.h"
#import "LHCommand.h"
#import "LHCommandRegistry.h"
#import "LHTaskQueue.h"
#import "LHCommandNodeUpdateTask.h"
#import "LHManualNodeUpdateTask.h"
#import "LHDriverChannelImpl.h"

NSString * const LHRouterNodeStateDidUpdateNotification = @"com.pixty.lighthouse.router.nodeStateDidUpdate";
NSString * const LHRouterNodeUserInfoKey = @"com.pixty.lighthouse.router.node";


@interface LHRouter () <LHNodeDataStorageDelegate>

@property (nonatomic, strong, readonly) LHComponents *components;

@property (nonatomic, strong, readonly) LHTaskQueue *commandQueue;

@end


@implementation LHRouter

#pragma mark - Init

- (instancetype)initWithRootNode:(id<LHNode>)rootNode
                   driverFactory:(id<LHDriverFactory>)driverFactory
                 commandRegistry:(id<LHCommandRegistry>)commandRegistry {
    self = [super init];
    if (!self) return nil;
    
    _components = [[LHComponents alloc] initWithGraph:[[LHGraph alloc] initWithRootNode:rootNode]
                                      nodeDataStorage:[[LHNodeDataStorage alloc] init]
                                        driverFactory:driverFactory
                                      commandRegistry:commandRegistry];
    
    _components.nodeDataStorage.delegate = self;
    
    LHNodeData *rootData = [_components.nodeDataStorage dataForNode:rootNode];
    rootData.state = LHNodeStateActive;
    
    return self;
}

#pragma mark - Updates

@synthesize commandQueue = _commandQueue;

- (LHTaskQueue *)commandQueue {
    if (!_commandQueue) {
        _commandQueue = [[LHTaskQueue alloc] init];
    }
    return _commandQueue;
}

- (void)executeCommand:(id<LHCommand>)command animated:(BOOL)animated {
    LHCommandNodeUpdateTask *task = [[LHCommandNodeUpdateTask alloc] initWithComponents:self.components
                                                                               animated:animated
                                                                                command:command];
    
    [self.commandQueue runTask:task];
}

- (void)executeUpdateWithBlock:(LHAsyncTaskBlock)block animated:(BOOL)animated {
    LHManualNodeUpdateTask *task = [[LHManualNodeUpdateTask alloc] initWithComponents:self.components
                                                                             animated:animated
                                                                                block:block];
    
    [self.commandQueue runTask:task];
}

#pragma mark - Node query

- (id<LHNode>)rootNode {
    return self.components.graph.rootNode;
}

- (NSSet *)initializedNodes {
    return self.components.nodeDataStorage.resolvedInitializedNodes;
}

- (LHNodeState)stateForNode:(id<LHNode>)node {
    return [self.components.nodeDataStorage resolvedStateForNode:node];
}

#pragma mark - KVO

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    
    if ([key isEqualToString:@"initializedNodes"]) {
        keyPaths = [keyPaths setByAddingObject:@"components.nodeDataStorage.resolvedInitializedNodes"];
    }
    
    return keyPaths;
}

#pragma mark - LHNodeDataStorageDelegate

- (void)nodeDataStorage:(LHNodeDataStorage *)storage didCreateData:(LHNodeData *)data forNode:(id<LHNode>)node {
    data.driver = [self createDriverForNode:node];
}

- (id<LHDriver>)createDriverForNode:(id<LHNode>)node {
    id<LHDriverChannel> channel = [[LHDriverChannelImpl alloc] initWithNode:node
                                                                 components:self.components
                                                                updateQueue:self.commandQueue];
    
    LHDriverTools *driverTools = [[LHDriverTools alloc] initWithDriverProvider:self.components.driverProvider
                                                                       channel:channel];
    
    id<LHDriver> driver = [self.components.driverFactory driverForNode:node withTools:driverTools];
    
    if (!driver) {
        return nil;
    }
    
    return driver;
}

- (void)nodeDataStorage:(LHNodeDataStorage *)storage willResetData:(LHNodeData *)data forNode:(id<LHNode>)node {
    [node resetChildrenState];
}

- (void)nodeDataStorage:(LHNodeDataStorage *)storage didChangeResolvedStateForNode:(id<LHNode>)node {
    if ([self.components.nodeDataStorage hasDataForNode:node]) {
        id<LHDriver> driver = [self.components.nodeDataStorage dataForNode:node].driver;
        [driver stateDidChange:[self.components.nodeDataStorage resolvedStateForNode:node]];
    }
    
    [self.delegate router:self nodeStateDidUpdate:node];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LHRouterNodeStateDidUpdateNotification
                                                        object:self
                                                      userInfo:@{ LHRouterNodeUserInfoKey: node }];
}

@end
