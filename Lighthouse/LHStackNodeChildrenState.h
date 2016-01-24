//
//  LHStackNodeChildrenState.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 20/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHNodeChildrenState.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHStackNodeChildrenState : NSObject <LHNodeChildrenState>

@property (nonatomic, copy, readonly) NSOrderedSet<id<LHNode>> *stack;

- (instancetype)initWithStack:(NSOrderedSet<id<LHNode>> *)stack NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END