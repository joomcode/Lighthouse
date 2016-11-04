//
//  LHTabNodeChildrenState.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 24/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHTabNodeChildrenState.h"
#import "LHTabNode.h"
#import "LHDebugDescription.h"

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

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    return [self lh_descriptionWithIndent:indent block:^(NSMutableString *buffer, NSString *indentString, NSUInteger indent) {
        [buffer appendFormat:@"%@activeChildren = %@\n", indentString, [self.activeChildren lh_descriptionWithIndent:indent]];
        [buffer appendFormat:@"%@inactiveChildren = %@\n", indentString, [self.inactiveChildren lh_descriptionWithIndent:indent]];
        [buffer appendFormat:@"%@activeChild = %@\n", indentString, [self.activeChild lh_descriptionWithIndent:indent]];
        [buffer appendFormat:@"%@activeChildIndex = %@\n", indentString, @(self.activeChildIndex)];
    }];
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
