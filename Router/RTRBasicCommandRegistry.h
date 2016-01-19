//
//  RTRBasicCommandRegistry.h
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRCommandRegistry.h"

@protocol RTRNode;
@protocol RTRTarget;

typedef id<RTRTarget> (^RTRCommandTargetProvidingBlock)(id<RTRCommand> command);

@interface RTRBasicCommandRegistry : NSObject <RTRCommandRegistry>

- (void)bindCommandClass:(Class)commandClass toTarget:(id<RTRTarget>)target;

- (void)bindCommandClass:(Class)commandClass toTargetWithActiveNode:(id<RTRNode>)node;

- (void)bindCommandClass:(Class)commandClass toTargetWithInactiveNode:(id<RTRNode>)node;

- (void)bindCommandClass:(Class)commandClass toBlock:(RTRCommandTargetProvidingBlock)block;

@end