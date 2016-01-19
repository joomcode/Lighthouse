//
//  LHDriverUpdateContext.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodeState.h"

@protocol LHNode;
@protocol LHCommand;
@protocol LHDriver;
@protocol LHNodeChildrenState;
@class LHTaskQueue;

NS_ASSUME_NONNULL_BEGIN


@protocol LHDriverUpdateContext <NSObject>

@property (nonatomic, assign, readonly, getter = isAnimated) BOOL animated;

@property (nonatomic, strong, readonly, nullable) id<LHCommand> command;

@property (nonatomic, strong, readonly, nullable) id<LHNodeChildrenState> childrenState;

@property (nonatomic, strong, readonly) LHTaskQueue *updateQueue;

- (id<LHDriver>)driverForNode:(id<LHNode>)node;

@end


NS_ASSUME_NONNULL_END