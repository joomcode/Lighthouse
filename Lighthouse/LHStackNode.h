//
//  LHStackNode.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNode.h"
#import "LHStackNodeChildrenState.h"
#import "LHDebugPrintable.h"

@class LHNodeTree;

NS_ASSUME_NONNULL_BEGIN


@interface LHStackNode : NSObject <LHNode, LHDebugPrintable>

@property (nonatomic, strong, readonly) LHStackNodeChildrenState *childrenState;

- (instancetype)initWithSingleBranch:(NSArray<id<LHNode>> *)nodes label:(nullable NSString *)label;

- (instancetype)initWithTree:(LHNodeTree *)tree label:(nullable NSString *)label;

- (instancetype)initWithTreeBlock:(void (^)(LHNodeTree *tree))treeBlock label:(nullable NSString *)label;

- (instancetype)initWithTrees:(NSArray<LHNodeTree *> *)trees label:(nullable NSString *)label NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
