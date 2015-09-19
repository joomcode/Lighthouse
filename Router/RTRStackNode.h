//
//  RTRStackNode.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNode.h"

@class RTRNodeTree;
@class RTRNodeForest;

@interface RTRStackNode : NSObject <RTRNode>

- (instancetype)initWithSingleBranch:(NSArray *)nodes;

- (instancetype)initWithTree:(RTRNodeTree *)tree;

- (instancetype)initWithForest:(RTRNodeForest *)forest;

@end
