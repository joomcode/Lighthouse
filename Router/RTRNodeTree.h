//
//  RTRNodeTree.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRTree.h"

@protocol RTRNode;

@interface RTRNodeTree : RTRTree<id<RTRNode>>

@end
