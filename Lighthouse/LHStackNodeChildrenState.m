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
    
    NSMutableSet *inactiveChildren = [stack.set mutableCopy];
    [inactiveChildren removeObject:stack.lastObject];
    
    _activeChildren = [NSSet setWithObject:stack.lastObject];
    _inactiveChildren = [inactiveChildren copy];
    
    return self;
}

#pragma mark - LHNodeChildrenState

@synthesize activeChildren = _activeChildren;
@synthesize inactiveChildren = _inactiveChildren;

#pragma mark - NSObject

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithString:[super description]];    
    [description appendFormat:@"{\n"];
    [description appendFormat:@"   activeChildren: %@\n",  self.activeChildren];
    [description appendFormat:@"   inactiveChildren: %@\n", self.inactiveChildren];
    [description appendFormat:@"   stack: %@\n", self.stack];
    [description appendFormat:@"}"];
    return [description copy];
}

@end
