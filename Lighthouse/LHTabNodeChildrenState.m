//
//  LHTabNodeChildrenState.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 24/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHTabNodeChildrenState.h"
#import "LHTabNode.h"
#import "LHDebugPrintable.h"

@interface LHTabNodeChildrenState () <LHDebugPrintable>

@end


@implementation LHTabNodeChildrenState

- (instancetype)initWithParent:(LHTabNode *)parent activeChildIndex:(NSUInteger)activeChildIndex {
    self = [super init];
    if (!self) return nil;
    
    _activeChild = [parent.orderedChildren objectAtIndex:activeChildIndex];
    _activeChildIndex = activeChildIndex;
    
    NSMutableSet *inactiveChildren = [parent.orderedChildren.set mutableCopy];
    [inactiveChildren removeObject:_activeChild];
    
    _activeChildren = [NSSet setWithObject:_activeChild];
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
              @"activeChild": self.activeChild,
              @"activeChildIndex": @(self.activeChildIndex) };
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
