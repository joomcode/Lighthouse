//
//  RTRNodeUpdateTask.h
//  Router
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRTask.h"

@protocol RTRNode;
@protocol RTRCommand;
@class RTRComponents;
@class RTRTaskQueue;

NS_ASSUME_NONNULL_BEGIN


@interface RTRNodeUpdateTask : NSObject <RTRTask>

@property (nonatomic, strong, readonly) RTRComponents *components;
@property (nonatomic, assign, readonly, getter = isAnimated) BOOL animated;

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)cancel;

@end


@interface RTRNodeUpdateTask (Subclassing)

- (nullable id<RTRCommand>)command;

- (void)updateNodes;

- (void)updateDriverForNode:(id<RTRNode>)node withUpdateQueue:(RTRTaskQueue *)updateQueue;

@end


NS_ASSUME_NONNULL_END