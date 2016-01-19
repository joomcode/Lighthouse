//
//  RTRGraph.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;
@class RTRNodeTree;

NS_ASSUME_NONNULL_BEGIN


@interface RTRGraph : NSObject

@property (nonatomic, strong, readonly) id<RTRNode> rootNode;

- (instancetype)initWithRootNode:(id<RTRNode>)rootNode;

- (instancetype)init NS_UNAVAILABLE;


- (nullable NSOrderedSet<id<RTRNode>> *)pathToNode:(id<RTRNode>)node;

- (nullable RTRNodeTree *)pathsToNodes:(NSSet<id<RTRNode>> *)nodes;


- (RTRNodeTree *)initializedNodesTree;

- (RTRNodeTree *)activeNodesTree;

@end


NS_ASSUME_NONNULL_END