//
//  LHStackNodeChildrenState.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 20/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHStackNodeChildrenState.h"
#import "LHDebugPrintable.h"

@interface LHStackNodeChildrenState () <LHDebugPrintable>

@end


@implementation LHStackNodeChildrenState

#pragma mark - Init

- (instancetype)initWithStack:(NSArray<id<LHNode>> *)stack {
    NSParameterAssert(stack.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    _stack = [stack copy];
    
    NSMutableSet *inactiveChildren = [NSMutableSet setWithArray:stack];
    [inactiveChildren removeObject:stack.lastObject];
    
    _activeChildren = [NSSet setWithObject:stack.lastObject];
    _inactiveChildren = [inactiveChildren copy];
    
    return self;
}

#pragma mark - LHNodeChildrenState

@synthesize activeChildren = _activeChildren;
@synthesize inactiveChildren = _inactiveChildren;

#pragma mark - LHDebugPrintable

- (NSDictionary<NSString *,id> *)lh_debugProperties {
    return @{ @"activeChildren": self.activeChildren,
              @"inactiveChildren": self.inactiveChildren,
              @"stack": self.stack };
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
