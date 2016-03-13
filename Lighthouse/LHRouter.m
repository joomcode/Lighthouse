//
//  LHRouter.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHRouter.h"
#import "LHRouterState.h"
#import "LHRouterObserver.h"
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

@interface LHRouter () <LHNodeDataStorageDelegate>

@property (nonatomic, strong, readonly) LHComponents *components;

@property (nonatomic, strong, readonly) LHTaskQueue *commandQueue;

@property (nonatomic, strong, readonly) NSPointerArray *observers;

@end


@implementation LHRouter

#pragma mark - Init

- (instancetype)initWithRootNode:(id<LHNode>)rootNode
                   driverFactory:(id<LHDriverFactory>)driverFactory
                 commandRegistry:(id<LHCommandRegistry>)commandRegistry {
    self = [super init];
    if (!self) return nil;
    
    _components = [[LHComponents alloc] initWithGraph:[[LHGraph alloc] initWithRootNode:rootNode]
                                      nodeDataStorage:[[LHNodeDataStorage alloc] initWithRootNode:rootNode]
                                        driverFactory:driverFactory
                                      commandRegistry:commandRegistry];
    
    _components.nodeDataStorage.delegate = self;
    
    _observers = [NSPointerArray weakObjectsPointerArray];
    
    return self;
}

#pragma mark - Properties

- (id<LHRouterState>)state {
    return self.components.nodeDataStorage.routerState;
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    
    if ([key isEqualToString:@"state"]) {
        keyPaths = [keyPaths setByAddingObject:@"components.nodeDataStorage.routerState"];
    }
    
    return keyPaths;
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

#pragma mark - Observers

- (void)addObserver:(id<LHRouterObserver>)observer {
    NSUInteger index = [self indexOfObserver:observer];
    if (index == NSNotFound) {
        [self.observers addPointer:(__bridge void *)observer];
    }
}

- (void)removeObserver:(id<LHRouterObserver>)observer {
    NSUInteger index = [self indexOfObserver:observer];
    if (index != NSNotFound) {
        [self.observers removePointerAtIndex:index];
    }
}

- (NSUInteger)indexOfObserver:(id<LHRouterObserver>)observer {
    for (NSUInteger index = 0; index < self.observers.count; ++index) {
        if (observer == [self.observers pointerAtIndex:index]) {
            return index;
        }
    }
    
    return NSNotFound;
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

- (void)nodeDataStorage:(LHNodeDataStorage *)storage didChangeResolvedStateForNodes:(NSArray<id<LHNode>> *)nodes {
    for (id<LHNode> node in nodes) {
        if ([self.components.nodeDataStorage hasDataForNode:node]) {
            id<LHDriver> driver = [self.components.nodeDataStorage dataForNode:node].driver;
            [driver stateDidChange:[self.state stateForNode:node]];
        }
    }
    
    for (id<LHRouterObserver> observer in self.observers) {
        if ([observer respondsToSelector:@selector(routerStateDidChange:)]) {
            [observer routerStateDidChange:self];
        }
    }
}

@end
