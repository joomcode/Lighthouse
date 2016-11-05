//
//  LHTarget.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHTarget.h"
#import "LHRouteHint.h"
#import "LHDebugDescription.h"

@implementation LHTarget

- (instancetype)init {
    return [self initWithActiveNodes:nil inactiveNodes:nil routeHint:nil];
}

- (instancetype)initWithActiveNodes:(NSSet<id<LHNode>> *)activeNodes
                      inactiveNodes:(NSSet<id<LHNode>> *)inactiveNodes
                          routeHint:(LHRouteHint *)hint {
    self = [super init];
    if (!self) return nil;
    
    _activeNodes = [activeNodes copy] ?: [NSSet set];
    _inactiveNodes = [inactiveNodes copy] ?: [NSSet set];
    _routeHint = hint;
    
    return self;
}

+ (instancetype)withActiveNode:(id<LHNode>)activeNode routeHint:(LHRouteHint *)hint {
    return [[[self class] alloc] initWithActiveNodes:[NSSet setWithObject:activeNode] inactiveNodes:nil routeHint:hint];
}

+ (instancetype)withActiveNode:(id<LHNode>)activeNode {
    return [self withActiveNode:activeNode routeHint:nil];
}

+ (instancetype)withActiveNodes:(NSArray<id<LHNode>> *)activeNodes routeHint:(LHRouteHint *)hint {
    return [[[self class] alloc] initWithActiveNodes:[NSSet setWithArray:activeNodes] inactiveNodes:nil routeHint:hint];
}

+ (instancetype)withActiveNodes:(NSArray<id<LHNode>> *)activeNodes {
    return [self withActiveNodes:activeNodes routeHint:nil];
}

+ (instancetype)withInactiveNode:(id<LHNode>)inactiveNode routeHint:(LHRouteHint *)hint {
    return [[[self class] alloc] initWithActiveNodes:nil inactiveNodes:[NSSet setWithObject:inactiveNode] routeHint:hint];
}

+ (instancetype)withInactiveNode:(id<LHNode>)inactiveNode {
    return [self withInactiveNode:inactiveNode routeHint:nil];
}

+ (instancetype)withInactiveNodes:(NSArray<id<LHNode>> *)inactiveNodes routeHint:(LHRouteHint *)hint {
    return [[[self class] alloc] initWithActiveNodes:nil inactiveNodes:[NSSet setWithArray:inactiveNodes] routeHint:hint];
}

+ (instancetype)withInactiveNodes:(NSArray<id<LHNode>> *)inactiveNodes {
    return [self withInactiveNodes:inactiveNodes routeHint:nil];
}

#pragma mark - NSObject

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    return [self lh_descriptionWithIndent:indent block:^(NSMutableString *buffer, NSString *indentString, NSUInteger indent) {
        [buffer appendFormat:@"%@activeNodes: %@\n", indentString, [self.activeNodes lh_descriptionWithIndent:indent]];
        [buffer appendFormat:@"%@inactiveNodes: %@\n", indentString, [self.inactiveNodes  lh_descriptionWithIndent:indent]];
        [buffer appendFormat:@"%@routeHint: %@\n", indentString, [self.routeHint  lh_descriptionWithIndent:indent]];
    }];
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
