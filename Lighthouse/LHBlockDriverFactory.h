//
//  LHBlockDriverFactory.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriverFactory.h"

@protocol LHNode;
@class LHDriverTools;

NS_ASSUME_NONNULL_BEGIN


typedef _Nonnull id<LHDriver> (^LHDriverFactoryBlock)(__kindof id<LHNode> node, LHDriverTools *tools);


@interface LHBlockDriverFactory : NSObject <LHDriverFactory>

- (void)bindNode:(id<LHNode>)node toBlock:(LHDriverFactoryBlock)block NS_SWIFT_NAME(bind(_:to:));

- (void)bindNodes:(NSArray<id<LHNode>> *)nodes toBlock:(LHDriverFactoryBlock)block NS_SWIFT_NAME(bind(_:to:));

- (void)bindNodeClass:(Class)nodeClass toBlock:(LHDriverFactoryBlock)block NS_SWIFT_NAME(bind(_:to:));

@end


NS_ASSUME_NONNULL_END
