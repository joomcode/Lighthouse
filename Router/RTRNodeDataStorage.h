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

NS_ASSUME_NONNULL_BEGIN


@interface RTRNodeDataStorage : NSObject

@property (nonatomic, weak, nullable) id<RTRNodeDataStorageDelegate> delegate;

@end


@interface RTRNodeDataStorage (Data)

- (BOOL)hasDataForNode:(id<RTRNode>)node;

- (RTRNodeData *)dataForNode:(id<RTRNode>)node;

- (void)resetDataForNode:(id<RTRNode>)node;

@end


@interface RTRNodeDataStorage (State)

@property (nonatomic, strong, readonly) NSSet<id<RTRNode>> *resolvedInitializedNodes;

- (RTRNodeState)resolvedStateForNode:(id<RTRNode>)node;

- (void)updateResolvedStateForAffectedNodeTree:(RTRNodeTree *)nodeTree;

@end


@protocol RTRNodeDataStorageDelegate <NSObject>

- (void)nodeDataStorage:(RTRNodeDataStorage *)storage didCreateData:(RTRNodeData *)data forNode:(id<RTRNode>)node;
- (void)nodeDataStorage:(RTRNodeDataStorage *)storage willResetData:(RTRNodeData *)data forNode:(id<RTRNode>)node;

- (void)nodeDataStorage:(RTRNodeDataStorage *)storage didChangeResolvedStateForNode:(id<RTRNode>)node;

@end


NS_ASSUME_NONNULL_END