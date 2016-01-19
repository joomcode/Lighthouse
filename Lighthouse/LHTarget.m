//
//  LHTarget.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHTarget.h"

@implementation LHTarget

@synthesize activeNodes = _activeNodes;
@synthesize inactiveNodes = _inactiveNodes;

- (instancetype)init {
    return [self initWithActiveNodes:nil inactiveNodes:nil];
}

- (instancetype)initWithActiveNodes:(NSSet<id<LHNode>> *)activeNodes inactiveNodes:(NSSet<id<LHNode>> *)inactiveNodes {
    self = [super init];
    if (!self) return nil;
    
    _activeNodes = [activeNodes copy] ?: [NSSet set];
    _inactiveNodes = [inactiveNodes copy] ?: [NSSet set];
    
    return self;
}

+ (instancetype)withActiveNode:(id<LHNode>)activeNode {
    return [[[self class] alloc] initWithActiveNodes:[NSSet setWithObject:activeNode] inactiveNodes:nil];
}

+ (instancetype)withActiveNodes:(NSArray<id<LHNode>> *)activeNodes {
    return [[[self class] alloc] initWithActiveNodes:[NSSet setWithArray:activeNodes] inactiveNodes:nil];
}

+ (instancetype)withInactiveNode:(id<LHNode>)inactiveNode {
    return [[[self class] alloc] initWithActiveNodes:nil inactiveNodes:[NSSet setWithObject:inactiveNode]];
}

+ (instancetype)withInactiveNodes:(NSArray<id<LHNode>> *)inactiveNodes {
    return [[[self class] alloc] initWithActiveNodes:nil inactiveNodes:[NSSet setWithArray:inactiveNodes]];
}

@end
