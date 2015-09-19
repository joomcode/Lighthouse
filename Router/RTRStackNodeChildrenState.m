//
//  RTRStackNodeChildrenState.m
//  Router
//
//  Created by Nick Tymchenko on 20/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRStackNodeChildrenState.h"

@implementation RTRStackNodeChildrenState

#pragma mark - Init

- (instancetype)initWithInitializedChildren:(NSOrderedSet *)initializedChildren
                  initializedChildrenByTree:(NSMapTable *)initializedChildrenByTree
{
    self = [super init];
    if (!self) return nil;
    
    _initializedChildren = [initializedChildren copy];
    _initializedChildrenByTree = [initializedChildrenByTree copy];
    
    return self;
}

#pragma mark - Stuff

@synthesize initializedChildrenByTree = _initializedChildrenByTree;

- (NSMapTable *)initializedChildrenByTree {
    if (!_initializedChildrenByTree) {
        _initializedChildrenByTree = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _initializedChildrenByTree;
}

#pragma mark - RTRNodeChildrenState

@synthesize initializedChildren = _initializedChildren;

- (NSOrderedSet *)activeChildren {
    return [NSOrderedSet orderedSetWithObject:self.initializedChildren.lastObject];
}

@end
