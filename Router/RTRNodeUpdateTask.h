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

@interface RTRNodeUpdateTask : NSObject <RTRTask>

@property (nonatomic, strong, readonly) RTRComponents *components;
@property (nonatomic, assign, readonly, getter = isAnimated) BOOL animated;

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated;

- (void)cancel;

@end


@interface RTRNodeUpdateTask (Subclassing)

- (id<RTRCommand>)command;

- (void)updateNodes;

- (void)updateDriverForNode:(id<RTRNode>)node withUpdateQueue:(RTRTaskQueue *)updateQueue;

@end