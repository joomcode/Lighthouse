//
//  LHGraph.h
//  Lighthouse
//
//  Created by Makarov Yury on 03/11/2016.
//  Copyright © 2016 Joom. All rights reserved.
//

#import "LHGraphEdge.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHGraph<__covariant NodeType> : NSObject <NSCopying>

@property (nonatomic, strong, readonly, nullable) NodeType rootNode;

@property (nonatomic, copy, readonly) NSSet<NodeType> *nodes;
@property (nonatomic, copy, readonly) NSArray<LHGraphEdge<NodeType> *> *edges;

@property (nonatomic, assign, readonly) NSUInteger nodeCount;

- (instancetype)initWithRootNode:(nullable NodeType)rootNode
                           edges:(nullable NSArray<LHGraphEdge<NodeType> *> *)edges NS_DESIGNATED_INITIALIZER;

- (nullable NSOrderedSet<NodeType> *)pathFromNode:(NodeType)source
                                           toNode:(NodeType)target
                                    visitingNodes:(nullable NSArray<NodeType> *)nodes
                                    visitingEdges:(nullable NSArray<LHGraphEdge<NodeType> *> *)edges;

- (nullable NSOrderedSet<NodeType> *)pathFromNode:(NodeType)source toNode:(NodeType)target;

- (BOOL)containsNode:(NodeType)node;

@end


@interface LHMutableGraph<__covariant NodeType> : LHGraph<NodeType> <NSMutableCopying>

@property (nonatomic, strong, nullable) NodeType rootNode;

- (void)addNode:(NodeType)node;

- (LHGraphEdge<NodeType> *)addEdgeFromNode:(NodeType)fromNode toNode:(NodeType)toNode label:(nullable NSString *)label;

- (LHGraphEdge<NodeType> *)addEdgeFromNode:(NodeType)fromNode toNode:(NodeType)toNode;

- (void)removeNode:(NodeType)node;

- (void)removeEdge:(LHGraphEdge *)edge;

@end

NS_ASSUME_NONNULL_END
