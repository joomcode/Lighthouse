//
//  LHStackNode.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNode.h"

@class LHNodeTree;

NS_ASSUME_NONNULL_BEGIN


@interface LHStackNode : NSObject <LHNode>

- (instancetype)initWithSingleBranch:(NSArray<id<LHNode>> *)nodes;

- (instancetype)initWithTree:(LHNodeTree *)tree NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithTreeBlock:(void (^)(LHNodeTree *tree))treeBlock;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END