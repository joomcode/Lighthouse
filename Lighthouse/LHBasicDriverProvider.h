//
//  LHBasicDriverProvider.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriverProvider.h"

NS_ASSUME_NONNULL_BEGIN


typedef _Nonnull id<LHDriver> (^LHDriverProvidingBlock)(id<LHNode> node);


@interface LHBasicDriverProvider : NSObject <LHDriverProvider>

- (void)bindNode:(id<LHNode>)node toBlock:(LHDriverProvidingBlock)block;

- (void)bindNodes:(NSArray *)nodes toBlock:(LHDriverProvidingBlock)block;

- (void)bindNodeClass:(Class)nodeClass toBlock:(LHDriverProvidingBlock)block;

@end


NS_ASSUME_NONNULL_END