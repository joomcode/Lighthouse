//
//  LHTabNode.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNode.h"
#import "LHTabNodeChildrenState.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHTabNode : NSObject <LHNode>

@property (nonatomic, copy, readonly) NSOrderedSet<id<LHNode>> *orderedChildren;

@property (nonatomic, strong, readonly) LHTabNodeChildrenState *childrenState;

- (instancetype)initWithChildren:(NSOrderedSet<id<LHNode>> *)children label:(nullable NSString *)label NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
