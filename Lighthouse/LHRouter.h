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
@protocol LHRouterDelegate;
@protocol LHRouterObserver;
@protocol LHRouterResumeToken;

NS_ASSUME_NONNULL_BEGIN

typedef __nullable id<LHCommand> (^LHRouterCommandBlock)(void);

typedef void (^LHRouterCompletionBlock)(void);


@interface LHRouter : NSObject

@property (nonatomic, strong, readonly) id<LHRouterState> state;

@property (nonatomic, assign, readonly, getter = isBusy) BOOL busy;

@property (nonatomic, assign, readonly, getter = isSuspended) BOOL suspended;


@property (nonatomic, weak, nullable) id<LHRouterDelegate> delegate;


- (instancetype)initWithRootNode:(id<LHNode>)rootNode
                   driverFactory:(id<LHDriverFactory>)driverFactory
                 commandRegistry:(id<LHCommandRegistry>)commandRegistry NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;


- (void)executeCommand:(id<LHCommand>)command;

- (void)executeCommand:(id<LHCommand>)command completion:(nullable LHRouterCompletionBlock)completion;

- (void)executeCommandWithBlock:(LHRouterCommandBlock)block completion:(nullable LHRouterCompletionBlock)completion;


- (id<LHRouterResumeToken>)suspend;


- (void)addObserver:(id<LHRouterObserver>)observer;

- (void)removeObserver:(id<LHRouterObserver>)observer;

@end


NS_ASSUME_NONNULL_END
