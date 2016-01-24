//
//  LHStackNodeChildrenState.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 20/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHStackNodeChildrenState.h"

@implementation LHStackNodeChildrenState

#pragma mark - Init

- (instancetype)initWithStack:(NSOrderedSet<id<LHNode>> *)stack {
    NSParameterAssert(stack.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    _stack = [stack copy];
    
    _initializedChildren = _stack.set;
    _activeChildren = [NSSet setWithObject:stack.lastObject];
    
    return self;
}

#pragma mark - LHNodeChildrenState

@synthesize initializedChildren = _initializedChildren;
@synthesize activeChildren = _activeChildren;

@end
