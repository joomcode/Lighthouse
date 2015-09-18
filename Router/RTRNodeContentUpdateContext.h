//
//  RTRNodeContentUpdateContext.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;
@protocol RTRCommand;
@protocol RTRNodeContent;
@protocol RTRTaskQueue;
@protocol RTRNodeChildrenState;

@protocol RTRNodeContentUpdateContext <NSObject>

@property (nonatomic, readonly, getter = isAnimated) BOOL animated;

@property (nonatomic, readonly) id<RTRCommand> command;

@property (nonatomic, readonly) id<RTRTaskQueue> updateQueue;

@property (nonatomic, readonly) id<RTRNodeChildrenState> childrenState;

- (id<RTRNodeContent>)contentForNode:(id<RTRNode>)node;

@end
