//
//  RTRLayer.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRLayer.h"

@implementation RTRLayer

- (instancetype)init {
    return [self initWithRootNode:nil];
}

- (instancetype)initWithRootNode:(id<RTRNode>)rootNode {
    NSParameterAssert(rootNode != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _rootNode = rootNode;
    
    return self;
}

@end
