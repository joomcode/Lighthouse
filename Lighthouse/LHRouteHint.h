//
//  LHRouteHint.h
//  Lighthouse
//
//  Created by Makarov Yury on 04/11/2016.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHGraphEdge.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LHNode;


@interface LHRouteHint : NSObject

@property (nonatomic, copy, readonly, nullable) NSOrderedSet<id<LHNode>> *nodes;
@property (nonatomic, copy, readonly, nullable) NSOrderedSet<LHGraphEdge<id<LHNode>> *> *edges;

- (instancetype)initWithNodes:(nullable NSOrderedSet<id<LHNode>> *)nodes
                        edges:(nullable NSOrderedSet<LHGraphEdge<id<LHNode>> *> *)edges NS_DESIGNATED_INITIALIZER;

+ (LHRouteHint *)hintWithNodes:(NSOrderedSet<id<LHNode>> *)nodes;

+ (LHRouteHint *)hintWithEdges:(NSOrderedSet<LHGraphEdge<id<LHNode>> *> *)edges;

+ (LHRouteHint *)hintWithNodes:(NSOrderedSet<id<LHNode>> *)nodes edges:(NSOrderedSet<LHGraphEdge<id<LHNode>> *> *)edges;

@end

NS_ASSUME_NONNULL_END
