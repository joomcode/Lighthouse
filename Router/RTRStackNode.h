//
//  RTRStackNode.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNode.h"

@class RTRNodeTree;

@interface RTRStackNode : NSObject <RTRNode>

- (instancetype)initWithTree:(RTRNodeTree *)tree;

- (instancetype)initWithSingleBranch:(NSArray *)nodes;

@end
