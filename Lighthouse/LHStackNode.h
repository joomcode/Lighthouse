//
//  LHStackNode.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNode.h"
#import "LHGraph.h"
#import "LHStackNodeChildrenState.h"
#import "LHDebugPrintable.h"

NS_ASSUME_NONNULL_BEGIN

@class LHMutableGraph;


@interface LHStackNode : NSObject <LHNode, LHDebugPrintable>

@property (nonatomic, strong, readonly) LHStackNodeChildrenState *childrenState;

- (instancetype)initWithSingleBranch:(NSArray<id<LHNode>> *)nodes label:(nullable NSString *)label;

- (instancetype)initWithGraph:(LHGraph<id<LHNode>> *)graph label:(nullable NSString *)label;

- (instancetype)initWithGraphBlock:(void (^)(LHMutableGraph<id<LHNode>> *graph))graphBlock label:(nullable NSString *)label;

- (instancetype)initWithGraphs:(NSArray<LHGraph<id<LHNode>> *> *)graphs label:(nullable NSString *)label NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
