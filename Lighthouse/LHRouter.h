//
//  LHRouter.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodePresentationState.h"

@protocol LHNode;
@protocol LHCommand;
@protocol LHCommandRegistry;
@protocol LHDriverProvider;
@protocol LHRouterDelegate;

NS_ASSUME_NONNULL_BEGIN


@interface LHRouter : NSObject

- (instancetype)initWithRootNode:(id<LHNode>)rootNode
                  driverProvider:(id<LHDriverProvider>)driverProvider
                 commandRegistry:(id<LHCommandRegistry>)commandRegistry NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;


- (void)executeCommand:(id<LHCommand>)command animated:(BOOL)animated;

- (void)executeUpdateWithBlock:(void (^)())block animated:(BOOL)animated;


@property (nonatomic, strong, readonly) id<LHNode> rootNode;

@property (nonatomic, strong, readonly) NSSet<id<LHNode>> *initializedNodes;

- (LHNodePresentationState)presentationStateForNode:(id<LHNode>)node;


@property (nonatomic, weak, nullable) id<LHRouterDelegate> delegate;

@end


NS_ASSUME_NONNULL_END