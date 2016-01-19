//
//  RTRTabNode.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNode.h"

NS_ASSUME_NONNULL_BEGIN


@interface RTRTabNode : NSObject <RTRNode>

- (instancetype)initWithChildren:(NSOrderedSet<id<RTRNode>> *)children NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END