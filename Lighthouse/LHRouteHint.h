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


typedef NS_ENUM(NSInteger, LHRouteHintOrigin) {
    LHRouteHintOriginActiveNode,
    LHRouteHintOriginRoot
};

@interface LHRouteHint : NSObject

@property (nonatomic, copy, readonly, nullable) NSOrderedSet<id<LHNode>> *nodes;
@property (nonatomic, assign, readonly) LHRouteHintOrigin origin;
@property (nonatomic, assign, getter = isBidirecational, readonly) BOOL bidirectional;

- (instancetype)initWithNodes:(nullable NSOrderedSet<id<LHNode>> *)nodes
                       origin:(LHRouteHintOrigin)origin
                bidirectional:(BOOL)bidirectional NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

+ (LHRouteHint *)hintWithNodes:(NSOrderedSet<id<LHNode>> *)nodes;

+ (LHRouteHint *)hintWithOrigin:(LHRouteHintOrigin)origin;

@end

NS_ASSUME_NONNULL_END
