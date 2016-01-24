//
//  LHTabNodeChildrenState.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 24/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHTabNodeChildrenState.h"
#import "LHTabNode.h"

@implementation LHTabNodeChildrenState

- (instancetype)initWithParent:(LHTabNode *)parent activeChildIndex:(NSUInteger)activeChildIndex {
    self = [super init];
    if (!self) return nil;
    
    _activeChild = [parent.orderedChildren objectAtIndex:activeChildIndex];
    _activeChildIndex = activeChildIndex;
    
    _initializedChildren = [parent.orderedChildren.set copy];
    _activeChildren = [NSSet setWithObject:_activeChild];
    
    return self;
}

#pragma mark - LHNodeChildrenState

@synthesize initializedChildren = _initializedChildren;
@synthesize activeChildren = _activeChildren;

@end
