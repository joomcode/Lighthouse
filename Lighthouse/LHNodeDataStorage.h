//
//  LHNodeDataStorage.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 24/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodeState.h"

@protocol LHNode;
@protocol LHRouterState;
@protocol LHNodeDataStorageDelegate;
@class LHNodeData;
@class LHNodeTree;

NS_ASSUME_NONNULL_BEGIN


@interface LHNodeDataStorage : NSObject

@property (nonatomic, weak, nullable) id<LHNodeDataStorageDelegate> delegate;

- (instancetype)initWithRootNode:(id<LHNode>)rootNode NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


@interface LHNodeDataStorage (Data)

- (BOOL)hasDataForNode:(id<LHNode>)node;

- (LHNodeData *)dataForNode:(id<LHNode>)node;

- (void)resetDataForNode:(id<LHNode>)node;

@end


// TODO: move this elsewhere
@interface LHNodeDataStorage (State)

@property (nonatomic, strong, readonly) id<LHRouterState> routerState;

- (void)updateRouterStateForAffectedNodeTree:(LHNodeTree *)nodeTree;

@end


@protocol LHNodeDataStorageDelegate <NSObject>

- (void)nodeDataStorage:(LHNodeDataStorage *)storage didCreateData:(LHNodeData *)data forNode:(id<LHNode>)node;
- (void)nodeDataStorage:(LHNodeDataStorage *)storage willResetData:(LHNodeData *)data forNode:(id<LHNode>)node;

- (void)nodeDataStorage:(LHNodeDataStorage *)storage didChangeResolvedStateForNode:(id<LHNode>)node;

@end


NS_ASSUME_NONNULL_END