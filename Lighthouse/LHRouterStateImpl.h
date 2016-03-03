//
//  LHRouterStateImpl.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 03/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHRouterState.h"

@class LHNodeTree;

NS_ASSUME_NONNULL_BEGIN


@interface LHRouterStateImpl : NSObject <LHRouterState, NSCopying>

- (instancetype)initWithRootNode:(id<LHNode>)rootNode NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (NSArray<id<LHNode>> *)updateForAffectedNodeTree:(LHNodeTree *)affectedNodeTree
                                    nodeStateBlock:(LHNodeState (^)(id<LHNode> node))nodeStateBlock;

@end


NS_ASSUME_NONNULL_END