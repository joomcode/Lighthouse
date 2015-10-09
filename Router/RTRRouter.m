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
#import "RTRDriver.h"
#import "RTRDriverProvider.h"
#import "RTRNodeDataStorage.h"
#import "RTRNodeData.h"
#import "RTRComponents.h"
#import "RTRGraph.h"
#import "RTRCommand.h"
#import "RTRCommandRegistry.h"
#import "RTRTaskQueue.h"
#import "RTRCommandNodeUpdateTask.h"
#import "RTRManualNodeUpdateTask.h"
#import "RTRDriverFeedbackChannelImpl.h"

NSString * const RTRRouterNodeStateDidUpdateNotification = @"com.pixty.router.nodeStateDidUpdate";
NSString * const RTRRouterNodeUserInfoKey = @"com.pixty.router.node";


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

- (id<RTRDriverProvider>)driverProvider {
    return self.components.driverProvider;
}

- (void)setDriverProvider:(id<RTRDriverProvider>)driverProvider {
    self.components.driverProvider = driverProvider;
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

#pragma mark - Updates

@synthesize commandQueue = _commandQueue;

- (RTRTaskQueue *)commandQueue {
    if (!_commandQueue) {
        _commandQueue = [[RTRTaskQueue alloc] init];
    }
    return _commandQueue;
}

- (void)executeCommand:(id<RTRCommand>)command animated:(BOOL)animated {
    RTRCommandNodeUpdateTask *task = [[RTRCommandNodeUpdateTask alloc] initWithComponents:self.components
                                                                                 animated:animated
                                                                                  command:command];
    
    [self.commandQueue runTask:task];
}

- (void)updateNodesWithBlock:(void (^)())block animated:(BOOL)animated {
    RTRManualNodeUpdateTask *task = [[RTRManualNodeUpdateTask alloc] initWithComponents:self.components
                                                                               animated:animated
                                                                        nodeUpdateBlock:block];
    
    [self.commandQueue runTask:task];
}

#pragma mark - Driver state query

- (NSSet *)initializedNodes {
    return self.components.nodeDataStorage.resolvedInitializedNodes;
}

- (RTRNodeState)stateForNode:(id<RTRNode>)node {
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

#pragma mark - RTRNodeDataStorageDelegate

- (void)nodeDataStorage:(RTRNodeDataStorage *)storage didCreateData:(RTRNodeData *)data forNode:(id<RTRNode>)node {
    data.driver = [self createDriverForNode:node];
}

- (id<RTRDriver>)createDriverForNode:(id<RTRNode>)node {
    id<RTRDriver> driver = [self.components.driverProvider driverForNode:node];
    
    if (!driver) {
        return nil;
    }
    
    if ([driver respondsToSelector:@selector(setFeedbackChannel:)]) {
        driver.feedbackChannel = [[RTRDriverFeedbackChannelImpl alloc] initWithNode:node
                                                                         components:self.components                                  
                                                                        updateQueue:self.commandQueue];
    }
    
    return driver;
}

- (void)nodeDataStorage:(RTRNodeDataStorage *)storage willResetData:(RTRNodeData *)data forNode:(id<RTRNode>)node {
    [node resetChildrenState];
}

- (void)nodeDataStorage:(RTRNodeDataStorage *)storage didChangeResolvedStateForNode:(id<RTRNode>)node {
    if ([self.components.nodeDataStorage hasDataForNode:node]) {
        id<RTRDriver> driver = [self.components.nodeDataStorage dataForNode:node].driver;
        
        if ([driver respondsToSelector:@selector(stateDidChange:)]) {
            [driver stateDidChange:[self.components.nodeDataStorage resolvedStateForNode:node]];
        }
    }
    
    [self.delegate router:self nodeStateDidUpdate:node];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RTRRouterNodeStateDidUpdateNotification
                                                        object:self
                                                      userInfo:@{ RTRRouterNodeUserInfoKey: node }];
}

@end
