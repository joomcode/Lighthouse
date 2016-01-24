//
//  LHNodeChildrenState.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNodeChildrenState.h"

@implementation LHNodeChildrenState

@synthesize initializedChildren = _initializedChildren;
@synthesize activeChildren = _activeChildren;

- (instancetype)init {
    return [self initWithInitializedChildren:nil activeChildren:nil];
}

- (instancetype)initWithInitializedChildren:(nullable NSSet<id<LHNode>> *)initializedChildren
                             activeChildren:(nullable NSSet<id<LHNode>> *)activeChildren {
    self = [super init];
    if (!self) return nil;
    
    _initializedChildren = [initializedChildren copy] ?: [NSSet set];
    _activeChildren = [activeChildren copy] ?: [NSSet set];
    
    NSAssert([_activeChildren isSubsetOfSet:_initializedChildren], @""); // TODO
        
    return self;
}

@end