//
//  LHFreeStackNode.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHNode.h"

@class LHNodeTree;

NS_ASSUME_NONNULL_BEGIN


@interface LHFreeStackNode : NSObject <LHNode>

- (instancetype)initWithTrees:(NSArray<LHNodeTree *> *)trees NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END