//
//  LHRouter.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodeState.h"
#import "LHTaskBlocks.h"

@protocol LHNode;
@protocol LHCommand;
@protocol LHCommandRegistry;
@protocol LHDriverFactory;
@protocol LHRouterState;
@protocol LHRouterResumeToken;
@protocol LHRouterObserver;

NS_ASSUME_NONNULL_BEGIN


@interface LHRouter : NSObject

@property (nonatomic, strong, readonly) id<LHRouterState> state;

@property (nonatomic, assign, readonly, getter = isSuspended) BOOL suspended;


- (instancetype)initWithRootNode:(id<LHNode>)rootNode
                   driverFactory:(id<LHDriverFactory>)driverFactory
                 commandRegistry:(id<LHCommandRegistry>)commandRegistry NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;


- (void)executeCommand:(id<LHCommand>)command animated:(BOOL)animated;

- (void)executeUpdateWithBlock:(LHAsyncTaskBlock)block animated:(BOOL)animated;


- (id<LHRouterResumeToken>)suspend;


- (void)addObserver:(id<LHRouterObserver>)observer;

- (void)removeObserver:(id<LHRouterObserver>)observer;

@end


NS_ASSUME_NONNULL_END