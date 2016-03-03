//
//  LHRouterState.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 03/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodeState.h"

@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN


@protocol LHRouterState <NSObject>

- (LHNodeState)stateForNode:(id<LHNode>)node;

- (NSSet<id<LHNode>> *)nodesWithStates:(LHNodeStateMask)states;

@end


NS_ASSUME_NONNULL_END