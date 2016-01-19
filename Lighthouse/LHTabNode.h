//
//  LHTabNode.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNode.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHTabNode : NSObject <LHNode>

- (instancetype)initWithChildren:(NSOrderedSet<id<LHNode>> *)children NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END