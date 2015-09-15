//
//  RTRStackNode.m
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRStackNode.h"
#import "RTRNodeTree.h"
#import "RTRNodeChildrenState.h"

@interface RTRStackNode ()

@property (nonatomic, copy, readonly) RTRNodeTree *tree;

@end


@implementation RTRStackNode

#pragma mark - Init

- (instancetype)init {
    return [self initWithTree:nil];
}

- (instancetype)initWithTree:(RTRNodeTree *)tree {
    NSParameterAssert(tree != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _tree = [tree copy];
    
    return self;
}

#pragma mark - RTRNode

- (NSSet *)allChildren {
    return [self.tree allNodes];
}

- (id<RTRNodeChildrenState>)activateChild:(id<RTRNode>)child withCurrentState:(id<RTRNodeChildrenState>)currentState {
    NSOrderedSet *path = [self.tree pathToNode:child];
    if (!path) {
        return nil;
    }
    
    NSOrderedSet *activeChildren = [NSOrderedSet orderedSetWithObject:path.lastObject];
    
    NSMutableOrderedSet *initializedChildren = [path mutableCopy];
    [initializedChildren removeObjectAtIndex:path.count - 1];
    
    return [[RTRNodeChildrenState alloc] initWithInitializedChildren:initializedChildren activeChildren:activeChildren];
}

@end
