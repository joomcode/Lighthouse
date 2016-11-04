//
//  LHTabNodeChildrenState.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 24/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHNodeChildrenState.h"
#import "LHDebugPrintable.h"

@class LHTabNode;

NS_ASSUME_NONNULL_BEGIN


@interface LHTabNodeChildrenState : NSObject <LHNodeChildrenState, LHDebugPrintable>

@property (nonatomic, strong, readonly) id<LHNode> activeChild;
@property (nonatomic, assign, readonly) NSUInteger activeChildIndex;

- (instancetype)initWithParent:(LHTabNode *)parent activeChildIndex:(NSUInteger)activeChildIndex;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
