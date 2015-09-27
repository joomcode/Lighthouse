//
//  RTRNodeDataStorage.h
//  Router
//
//  Created by Nick Tymchenko on 24/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTRNodeState.h"

@protocol RTRNode;
@protocol RTRNodeDataStorageDelegate;
@class RTRNodeData;
@class RTRNodeTree;

@interface RTRNodeDataStorage : NSObject

@property (nonatomic, weak) id<RTRNodeDataStorageDelegate> delegate;

@end


@interface RTRNodeDataStorage (Data)

- (BOOL)hasDataForNode:(id<RTRNode>)node;

- (RTRNodeData *)dataForNode:(id<RTRNode>)node;

- (void)resetDataForNode:(id<RTRNode>)node;

@end


@interface RTRNodeDataStorage (State)

- (NSSet *)initializedNodes;

- (RTRNodeState)resolvedStateForNode:(id<RTRNode>)node;

- (void)updateResolvedStateForNodes:(RTRNodeTree *)nodes;

@end


@protocol RTRNodeDataStorageDelegate <NSObject>

- (void)nodeDataStorage:(RTRNodeDataStorage *)storage didChangeResolvedStateForNode:(id<RTRNode>)node;

@end