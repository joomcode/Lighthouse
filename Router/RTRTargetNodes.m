//
//  RTRTargetNodes.m
//  Router
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRTargetNodes.h"

@implementation RTRTargetNodes

- (instancetype)init {
    return [self initWithActiveNodes:nil inactiveNodes:nil];
}

- (instancetype)initWithActiveNode:(id<RTRNode>)activeNode {
    return [self initWithActiveNodes:[NSSet setWithObject:activeNode] inactiveNodes:nil];
}

- (instancetype)initWithInactiveNode:(id<RTRNode>)inactiveNode {
    return [self initWithActiveNodes:nil inactiveNodes:[NSSet setWithObject:inactiveNode]];
}

- (instancetype)initWithActiveNodes:(NSSet *)activeNodes inactiveNodes:(NSSet *)inactiveNodes {
    self = [super init];
    if (!self) return nil;
    
    _activeNodes = [activeNodes copy] ?: [NSSet set];
    _inactiveNodes = [inactiveNodes copy] ?: [NSSet set];
    
    return self;
}

@end
