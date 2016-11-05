//
//  LHNodeTree.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHTree.h"

@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN


@interface LHNodeTree : LHTree<id<LHNode>>

+ (instancetype)treeWithDescendantsOfNode:(id<LHNode>)node;

+ (instancetype)treeWithInitializedDescendantsOfNode:(id<LHNode>)node;

+ (instancetype)treeWithActiveDescendantsOfNode:(id<LHNode>)node;

- (LHNodeTree *)activeNodesTree;

- (LHNodeTree *)initializedNodesTree;

@end


NS_ASSUME_NONNULL_END
