//
//  LHRouter.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHRouter.h"
#import "LHRouterState.h"
#import "LHRouterDelegateImpl.h"
#import "LHRouterObserver.h"
#import "LHRouterResumeTokenImpl.h"
#import "LHNode.h"
#import "LHDriver.h"
#import "LHDriverFactory.h"
#import "LHDriverTools.h"
#import "LHNodeDataStorage.h"
#import "LHNodeData.h"
#import "LHNodeTree.h"
#import "LHComponents.h"
#import "LHCommand.h"
#import "LHCommandRegistry.h"
#import "LHTaskQueueImpl.h"
#import "LHBlockTask.h"
#import "LHCommandNodeUpdateTask.h"
#import "LHManualNodeUpdateTask.h"
#import "LHDriverChannelImpl.h"
#import "LHMacro.h"

@interface LHRouter () <LHNodeDataStorageDelegate>

@property (nonatomic, strong, readonly) LHComponents *components;

@property (nonatomic, strong, readonly) LHTaskQueueImpl *commandQueue;

@property (nonatomic, strong, readonly) NSPointerArray *observers;

@property (nonatomic, strong, readonly) NSHashTable<id<LHRouterResumeToken>> *resumeTokens;

@property (nonatomic, strong, readonly) LHRouterDelegateImpl *internalDelegate;

@end


@implementation LHRouter

#pragma mark - Init

- (instancetype)initWithRootNode:(id<LHNode>)rootNode
                   driverFactory:(id<LHDriverFactory>)driverFactory
                 commandRegistry:(id<LHCommandRegistry>)commandRegistry {
    self = [super init];
    if (!self) return nil;
    
    _components = [[LHComponents alloc] initWithTree:[LHNodeTree treeWithDescendantsOfNode:rootNode]
                                     nodeDataStorage:[[LHNodeDataStorage alloc] initWithRootNode:rootNode]
                                       driverFactory:driverFactory
                                     commandRegistry:commandRegistry];
    
    _components.nodeDataStorage.delegate = self;
    
    _observers = [NSPointerArray weakObjectsPointerArray];
    
    _resumeTokens = [NSHashTable weakObjectsHashTable];
    
    _internalDelegate = [[LHRouterDelegateImpl alloc] init];
    
    return self;
}

#pragma mark - Properties

- (id<LHRouterState>)state {
    return self.components.nodeDataStorage.routerState;
}

- (BOOL)isBusy {
    return self.commandQueue.busy;
}

- (BOOL)isSuspended {
    return self.commandQueue.suspended;
}

- (id<LHRouterDelegate>)delegate {
    return self.internalDelegate.delegate;
}

- (void)setDelegate:(id<LHRouterDelegate>)delegate {
    self.internalDelegate.delegate = delegate;
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    
    if ([key isEqualToString:LHClassKeyPath(LHRouter, state)]) {
        keyPaths = [keyPaths setByAddingObject:LHClassKeyPath(LHRouter, components.nodeDataStorage.routerState)];
    } else if ([key isEqualToString:LHClassKeyPath(LHRouter, busy)]) {
        keyPaths = [keyPaths setByAddingObject:LHClassKeyPath(LHRouter, commandQueue.busy)];
    } else if ([key isEqualToString:LHClassKeyPath(LHRouter, suspended)]) {
        keyPaths = [keyPaths setByAddingObject:LHClassKeyPath(LHRouter, commandQueue.suspended)];
    }
    
    return keyPaths;
}

#pragma mark - Command Execution

@synthesize commandQueue = _commandQueue;

- (LHTaskQueueImpl *)commandQueue {
    if (!_commandQueue) {
        _commandQueue = [[LHTaskQueueImpl alloc] init];
    }
    return _commandQueue;
}

- (void)executeCommand:(id<LHCommand>)command {
    [self executeCommand:command completion:nil];
}

- (void)executeCommand:(id<LHCommand>)command completion:(void (^)())completion {
    [self executeCommandWithBlock:^id<LHCommand> {
        return command;
    } completion:completion];
}

- (void)executeCommandWithBlock:(LHRouterCommandBlock)block completion:(nullable LHRouterCompletionBlock)completion {
    id<LHTask> wrapperTask = [[LHBlockTask alloc] initWithAsyncBlock:^(LHTaskCompletionBlock wrapperCompletion) {
        id<LHCommand> command = block();
        
        if (!command) {
            wrapperCompletion();
            return;
        }
        
        [self doExecuteCommand:command completion:^{
            if (completion) {
                completion();
            }
            wrapperCompletion();
        }];
    }];
    
    [self.commandQueue runTask:wrapperTask];
}

- (void)doExecuteCommand:(id<LHCommand>)command completion:(LHTaskCompletionBlock)completion {
    [self notifyObserversForSelector:@selector(router:willExecuteCommand:) withBlock:^(id<LHRouterObserver> observer) {
        [observer router:self willExecuteCommand:command];
    }];
    
    BOOL shouldAnimate = [self.internalDelegate router:self shouldAnimateDriverUpdatesForCommand:command];
    
    id<LHTask> task = [[LHCommandNodeUpdateTask alloc] initWithComponents:self.components
                                                                 animated:shouldAnimate
                                                                  command:command];
    
    [task startWithCompletionBlock:^{
        [self notifyObserversForSelector:@selector(router:didExecuteCommand:) withBlock:^(id<LHRouterObserver> observer) {
            [observer router:self didExecuteCommand:command];
        }];
        
        completion();
    }];
}

#pragma mark - Suspending

- (id<LHRouterResumeToken>)suspend {
    __weak typeof(self) weakSelf = self;
    
    LHRouterResumeTokenImpl *resumeToken = [[LHRouterResumeTokenImpl alloc] initWithResumeBlock:^(LHRouterResumeTokenImpl *token) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf removeResumeToken:token];
    }];
    
    [self addResumeToken:resumeToken];
    
    return resumeToken;
}

- (void)addResumeToken:(id<LHRouterResumeToken>)token {
    [self.resumeTokens addObject:token];
    
    if (self.resumeTokens.count > 0) {
        self.commandQueue.suspended = YES;
    }
}

- (void)removeResumeToken:(id<LHRouterResumeToken>)token {
    [self.resumeTokens removeObject:token];
    
    if (self.resumeTokens.count == 0) {
        self.commandQueue.suspended = NO;
    }
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

- (void)notifyObserversForSelector:(SEL)selector withBlock:(void (^)(id<LHRouterObserver> observer))block {
    for (id<LHRouterObserver> observer in self.observers) {
        if ([observer respondsToSelector:selector]) {
            block(observer);
        }
    }
}

#pragma mark - LHNodeDataStorageDelegate

- (void)nodeDataStorage:(LHNodeDataStorage *)storage didCreateData:(LHNodeData *)data forNode:(id<LHNode>)node {
    NSArray<id<LHDriver>> *drivers = data.drivers ?: @[];
    data.drivers = [drivers arrayByAddingObject:[self createDriverForNode:node]];
}

- (id<LHDriver>)createDriverForNode:(id<LHNode>)node {
    id<LHDriverChannel> channel = [[LHDriverChannelImpl alloc] initWithNode:node
                                                                 components:self.components
                                                                updateQueue:self.commandQueue];
    
    LHDriverTools *driverTools = [[LHDriverTools alloc] initWithDriverProvider:self.components.driverProvider
                                                                       channel:channel];
    
    return [self.components.driverFactory driverForNode:node withTools:driverTools];
}

- (void)nodeDataStorage:(LHNodeDataStorage *)storage willResetData:(LHNodeData *)data forNode:(id<LHNode>)node {
    [node resetChildrenState];
}

- (void)nodeDataStorage:(LHNodeDataStorage *)storage didChangeResolvedStateForNodes:(NSArray<id<LHNode>> *)nodes {
    for (id<LHNode> node in nodes) {
        if ([self.components.nodeDataStorage hasDataForNode:node]) {
            id<LHDriver> driver = [self.components.nodeDataStorage dataForNode:node].drivers.lastObject;
            [driver stateDidChange:[self.state stateForNode:node]];
        }
    }
    
    [self notifyObserversForSelector:@selector(routerStateDidChange:) withBlock:^(id<LHRouterObserver> observer) {
        [observer routerStateDidChange:self];
    }];
}

@end
