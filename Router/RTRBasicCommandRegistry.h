//
//  RTRBasicCommandRegistry.h
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRCommandRegistry.h"

@protocol RTRNode;
@class RTRTargetNodes;

typedef RTRTargetNodes * (^RTRCommandTargetNodesProvidingBlock)(id<RTRCommand> command);

@interface RTRBasicCommandRegistry : NSObject <RTRCommandRegistry>

- (void)bindCommandClass:(Class)commandClass toActiveNodeTarget:(id<RTRNode>)node;

- (void)bindCommandClass:(Class)commandClass toInactiveNodeTarget:(id<RTRNode>)node;

- (void)bindCommandClass:(Class)commandClass toTargetNodes:(RTRTargetNodes *)targetNodes;

- (void)bindCommandClass:(Class)commandClass toBlock:(RTRCommandTargetNodesProvidingBlock)block;

@end