//
//  LHNodeTree.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHTree.h"

@protocol LHNode;

@interface LHNodeTree : LHTree<id<LHNode>>

@end