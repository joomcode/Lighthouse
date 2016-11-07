//
//  LHGraph.h
//  Lighthouse
//
//  Created by Makarov Yury on 03/11/2016.
//  Copyright © 2016 Joom. All rights reserved.
//

#import "LHGraphEdge.h"

NS_ASSUME_NONNULL_BEGIN

@interface LHGraph<__covariant NodeType> : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, strong, readonly, nullable) NodeType rootNode;

@property (nonatomic, copy, readonly) NSSet<NodeType> *nodes;

@property (nonatomic, copy, readonly) NSSet<LHGraphEdge<NodeType> *> *edges;

- (instancetype)initWithRootNode:(nullable NodeType)rootNode
                           nodes:(nullable NSSet<NodeType> *)nodes
                           edges:(nullable NSSet<LHGraphEdge<NodeType> *> *)edges NS_DESIGNATED_INITIALIZER;

- (nullable NSOrderedSet<NodeType> *)pathFromNode:(NodeType)source
                                           toNode:(NodeType)target
                                    visitingNodes:(nullable NSOrderedSet<NodeType> *)nodes;

- (nullable NSOrderedSet<NodeType> *)pathFromNode:(NodeType)source toNode:(NodeType)target;

- (NSSet<LHGraphEdge<NodeType> *> *)outgoingEdgesForNode:(NodeType)node;

- (BOOL)hasEdgeFromNode:(NodeType)source toNode:(NodeType)target;

@end


@interface LHMutableGraph<__covariant NodeType> : LHGraph<NodeType>

@property (nonatomic, strong, nullable) NodeType rootNode;

- (void)addNode:(NodeType)node;

- (void)removeNode:(NodeType)node;

- (LHGraphEdge<NodeType> *)addEdgeFromNode:(NodeType)fromNode toNode:(NodeType)toNode label:(nullable NSString *)label;

- (LHGraphEdge<NodeType> *)addEdgeFromNode:(NodeType)fromNode toNode:(NodeType)toNode;

- (NSArray<LHGraphEdge<NodeType> *> *)addBidirectionalEdgeFromNode:(NodeType)fromNode toNode:(NodeType)toNode;

- (void)removeEdge:(LHGraphEdge *)edge;

@end

NS_ASSUME_NONNULL_END
