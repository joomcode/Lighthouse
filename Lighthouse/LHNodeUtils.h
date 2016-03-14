//
//  LHNodeUtils.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 03/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodeModelState.h"

@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN


@interface LHNodeUtils : NSObject

// TODO (swift): move these to the protocol extension.

+ (LHNodeModelState)node:(id<LHNode>)node modelStateForChild:(id<LHNode>)childNode;

+ (void)enumerateChildrenOfNode:(id<LHNode>)node withBlock:(void (^)(id<LHNode> childNode, LHNodeModelState childModelState))block;

@end


NS_ASSUME_NONNULL_END