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
@protocol RTRNodeContentProvider;
@protocol RTRRouterDelegate;


@interface RTRRouter : NSObject

@property (nonatomic, strong) id<RTRNode> rootNode;

@property (nonatomic, strong) id<RTRNodeContentProvider> nodeContentProvider;

@property (nonatomic, strong) id<RTRCommandRegistry> commandRegistry;

@property (nonatomic, weak) id<RTRRouterDelegate> delegate;


- (void)executeCommand:(id<RTRCommand>)command animated:(BOOL)animated;

- (void)updateNodesWithBlock:(void (^)())block animated:(BOOL)animated;


@property (nonatomic, readonly) NSSet *initializedNodes;

- (RTRNodeState)stateForNode:(id<RTRNode>)node;

@end