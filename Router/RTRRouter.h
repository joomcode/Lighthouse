//
//  RTRRouter.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTRNodeState.h"

@protocol RTRNode;
@protocol RTRCommand;
@protocol RTRCommandRegistry;
@protocol RTRDriverProvider;
@protocol RTRRouterDelegate;

NS_ASSUME_NONNULL_BEGIN


@interface RTRRouter : NSObject

- (instancetype)initWithRootNode:(id<RTRNode>)rootNode
                  driverProvider:(id<RTRDriverProvider>)driverProvider
                 commandRegistry:(id<RTRCommandRegistry>)commandRegistry NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;


- (void)executeCommand:(id<RTRCommand>)command animated:(BOOL)animated;

- (void)executeUpdateWithBlock:(void (^)())block animated:(BOOL)animated;


@property (nonatomic, strong, readonly) id<RTRNode> rootNode;

@property (nonatomic, strong, readonly) NSSet<id<RTRNode>> *initializedNodes;

- (RTRNodeState)stateForNode:(id<RTRNode>)node;


@property (nonatomic, weak, nullable) id<RTRRouterDelegate> delegate;

@end


NS_ASSUME_NONNULL_END