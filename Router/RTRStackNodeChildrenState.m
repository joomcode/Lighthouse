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

- (instancetype)initWithStack:(NSOrderedSet<id<RTRNode>> *)stack {
    NSParameterAssert(stack.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    _initializedChildren = [stack copy];
    _activeChildren = [NSSet setWithObject:stack.lastObject];
    
    return self;
}

#pragma mark - RTRNodeChildrenState

@synthesize initializedChildren = _initializedChildren;
@synthesize activeChildren = _activeChildren;

@end
