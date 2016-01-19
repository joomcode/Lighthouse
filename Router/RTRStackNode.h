//
//  RTRStackNode.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNode.h"

@class RTRNodeTree;

NS_ASSUME_NONNULL_BEGIN


@interface RTRStackNode : NSObject <RTRNode>

- (instancetype)initWithSingleBranch:(NSArray<id<RTRNode>> *)nodes;

- (instancetype)initWithTree:(RTRNodeTree *)tree NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END