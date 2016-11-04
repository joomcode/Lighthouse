//
//  LHStackNodeChildrenState.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 20/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHStackNodeChildrenState.h"
#import "LHDebugDescription.h"

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

#pragma mark - LHDebugPrintable

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    return [self lh_descriptionWithIndent:indent block:^(NSMutableString *buffer, NSString *indentString, NSUInteger indent) {
        [buffer appendFormat:@"%@activeChildren = %@\n", indentString, [self.activeChildren lh_descriptionWithIndent:indent]];
        [buffer appendFormat:@"%@inactiveChildren = %@\n", indentString, [self.inactiveChildren lh_descriptionWithIndent:indent]];
        [buffer appendFormat:@"%@stack = %@\n", indentString, [self.stack lh_descriptionWithIndent:indent]];
    }];
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
