//
//  LHBasicCommandRegistry.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHCommandRegistry.h"

@protocol LHNode;
@class LHTarget;

NS_ASSUME_NONNULL_BEGIN


typedef LHTarget * _Nullable (^LHCommandTargetProvidingBlock)(__kindof id<LHCommand> command);


@interface LHBasicCommandRegistry : NSObject <LHCommandRegistry>

- (void)bindCommandClass:(Class)commandClass toTarget:(LHTarget *)target;

- (void)bindCommandClass:(Class)commandClass toTargetWithActiveNode:(id<LHNode>)node;

- (void)bindCommandClass:(Class)commandClass toTargetWithInactiveNode:(id<LHNode>)node;

- (void)bindCommandClass:(Class)commandClass toBlock:(LHCommandTargetProvidingBlock)block;

@end


NS_ASSUME_NONNULL_END