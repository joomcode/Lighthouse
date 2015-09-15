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
    return [self initWithInitializedChildren:nil activeChildren:nil];
}

- (instancetype)initWithInitializedChildren:(NSOrderedSet *)initializedChildren
                             activeChildren:(NSOrderedSet *)activeChildren
{
    self = [super init];
    if (!self) return nil;
    
    _initializedChildren = [initializedChildren copy] ?: [NSOrderedSet orderedSet];
    _activeChildren = [activeChildren copy] ?: [NSOrderedSet orderedSet];
    
    return self;
}

@end