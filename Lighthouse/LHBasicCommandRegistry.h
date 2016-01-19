//
//  LHBasicCommandRegistry.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHCommandRegistry.h"

@protocol LHNode;
@protocol LHTarget;

NS_ASSUME_NONNULL_BEGIN


typedef _Nullable id<LHTarget> (^LHCommandTargetProvidingBlock)(id<LHCommand> command);


@interface LHBasicCommandRegistry : NSObject <LHCommandRegistry>

- (void)bindCommandClass:(Class)commandClass toTarget:(id<LHTarget>)target;

- (void)bindCommandClass:(Class)commandClass toTargetWithActiveNode:(id<LHNode>)node;

- (void)bindCommandClass:(Class)commandClass toTargetWithInactiveNode:(id<LHNode>)node;

- (void)bindCommandClass:(Class)commandClass toBlock:(LHCommandTargetProvidingBlock)block;

@end


NS_ASSUME_NONNULL_END