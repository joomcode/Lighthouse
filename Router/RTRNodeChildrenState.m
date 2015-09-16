//
//  RTRNodeChildrenState.m
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeChildrenState.h"

@implementation RTRNodeChildrenState

@synthesize initializedChildren = _initializedChildren;
@synthesize activeChildren = _activeChildren;

- (instancetype)init {
    return [self initWithInitializedChildren:nil activeChildrenIndexSet:nil];
}

- (instancetype)initWithInitializedChildren:(NSOrderedSet *)initializedChildren
                     activeChildrenIndexSet:(NSIndexSet *)activeChildrenIndexSet
{
    self = [super init];
    if (!self) return nil;
    
    _initializedChildren = [initializedChildren copy] ?: [NSOrderedSet orderedSet];
    
    if (activeChildrenIndexSet) {
        _activeChildren = [NSOrderedSet orderedSetWithArray:[_initializedChildren objectsAtIndexes:activeChildrenIndexSet]];
    } else {
        _activeChildren = [NSOrderedSet orderedSet];
    }
    
    return self;
}

@end