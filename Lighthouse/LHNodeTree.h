//
//  LHNodeTree.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHTree.h"
#import "LHNodeState.h"

@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN


@interface LHNodeTree : LHTree<id<LHNode>>

+ (instancetype)treeWithDescendantsOfNode:(id<LHNode>)node withStates:(LHNodeStateMask)stateMask;

@end


NS_ASSUME_NONNULL_END