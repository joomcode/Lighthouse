//
//  RTRStackNodeChildrenState.h
//  Router
//
//  Created by Nick Tymchenko on 20/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRNodeChildrenState.h"

@class RTRNodeTree;

NS_ASSUME_NONNULL_BEGIN


@interface RTRStackNodeChildrenState : NSObject <RTRNodeChildrenState>

- (instancetype)initWithStack:(NSOrderedSet<id<RTRNode>> *)stack NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END