//
//  LHNodeData.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNodeData.h"
#import "LHNode.h"
#import "LHNodeChildrenState.h"

@implementation LHNodeData

- (instancetype)initWithNode:(id<LHNode>)node {
    self = [super init];
    if (!self) return nil;
    
    _node = node;
    
    return self;
}

@end
