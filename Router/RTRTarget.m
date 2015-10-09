//
//  RTRTarget.m
//  Router
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRTarget.h"

@implementation RTRTarget

@synthesize activeNodes = _activeNodes;
@synthesize inactiveNodes = _inactiveNodes;

- (instancetype)init {
    return [self initWithActiveNodes:nil inactiveNodes:nil];
}

- (instancetype)initWithActiveNodes:(NSSet *)activeNodes inactiveNodes:(NSSet *)inactiveNodes {
    self = [super init];
    if (!self) return nil;
    
    _activeNodes = [activeNodes copy] ?: [NSSet set];
    _inactiveNodes = [inactiveNodes copy] ?: [NSSet set];
    
    return self;
}

+ (instancetype)withActiveNode:(id<RTRNode>)activeNode {
    return [[[self class] alloc] initWithActiveNodes:[NSSet setWithObject:activeNode] inactiveNodes:nil];
}

+ (instancetype)withActiveNodes:(NSArray *)activeNodes {
    return [[[self class] alloc] initWithActiveNodes:[NSSet setWithArray:activeNodes] inactiveNodes:nil];
}

+ (instancetype)withInactiveNode:(id<RTRNode>)inactiveNode {
    return [[[self class] alloc] initWithActiveNodes:nil inactiveNodes:[NSSet setWithObject:inactiveNode]];
}

+ (instancetype)withInactiveNodes:(NSArray *)inactiveNodes {
    return [[[self class] alloc] initWithActiveNodes:nil inactiveNodes:[NSSet setWithArray:inactiveNodes]];
}

@end
