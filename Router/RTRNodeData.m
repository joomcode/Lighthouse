//
//  RTRNodeData.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeData.h"
#import "RTRNode.h"
#import "RTRNodeChildrenState.h"

@implementation RTRNodeData

- (instancetype)init {
    return [self initWithNode:nil];
}

- (instancetype)initWithNode:(id<RTRNode>)node {
    NSParameterAssert(node != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _node = node;
    
    return self;
}

@end
