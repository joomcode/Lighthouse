//
//  RTRDriverUpdateContext.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTRNodeState.h"

@protocol RTRNode;
@protocol RTRCommand;
@protocol RTRDriver;
@protocol RTRNodeChildrenState;
@class RTRTaskQueue;

NS_ASSUME_NONNULL_BEGIN


@protocol RTRDriverUpdateContext <NSObject>

@property (nonatomic, readonly, getter = isAnimated) BOOL animated;

@property (nonatomic, readonly, nullable) id<RTRCommand> command;

@property (nonatomic, readonly, nullable) id<RTRNodeChildrenState> childrenState;

@property (nonatomic, readonly) RTRTaskQueue *updateQueue;

- (id<RTRDriver>)driverForNode:(id<RTRNode>)node;

@end


NS_ASSUME_NONNULL_END