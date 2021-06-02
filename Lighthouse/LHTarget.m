//
//  LHTarget.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHTarget.h"
#import "LHRouteHint.h"
#import "LHDebugPrintable.h"

@interface LHTarget () <LHDebugPrintable>

@end


@implementation LHTarget

- (instancetype)init {
    return [self initWithActiveNodes:nil inactiveNodes:nil routeHint:nil];
}

- (instancetype)initWithActiveNodes:(nullable NSSet<id<LHNode>> *)activeNodes
                      inactiveNodes:(nullable NSSet<id<LHNode>> *)inactiveNodes
                          routeHint:(nullable LHRouteHint *)hint {
    self = [super init];
    if (!self) return nil;
    
    _activeNodes = [activeNodes copy] ?: [NSSet set];
    _inactiveNodes = [inactiveNodes copy] ?: [NSSet set];
    _routeHint = hint;
    
    return self;
}

+ (instancetype)withActiveNodes:(NSArray<id<LHNode>> *)activeNodes inactiveNodes:(NSArray<id<LHNode>> *)inactiveNodes {
    return [[[self class] alloc] initWithActiveNodes:[NSSet setWithArray:activeNodes]
                                      inactiveNodes:[NSSet setWithArray:inactiveNodes]
                                          routeHint:nil];
}

+ (instancetype)withActiveNode:(id<LHNode>)activeNode routeHint:(LHRouteHint *)hint {
    return [[[self class] alloc] initWithActiveNodes:[NSSet setWithObject:activeNode] inactiveNodes:nil routeHint:hint];
}

+ (instancetype)withActiveNode:(id<LHNode>)activeNode routeNodes:(NSArray<id<LHNode>> *)routeNodes {
    LHRouteHint *hint = [LHRouteHint hintWithNodes:[NSOrderedSet orderedSetWithArray:routeNodes]];
    return [self withActiveNode:activeNode routeHint:hint];
}

+ (instancetype)withActiveNode:(id<LHNode>)activeNode routeOrigin:(LHRouteHintOrigin)routeOrigin {
    return [self withActiveNode:activeNode routeHint:[LHRouteHint hintWithOrigin:routeOrigin]];
}

+ (instancetype)withActiveNode:(id<LHNode>)activeNode {
    return [self withActiveNode:activeNode routeHint:nil];
}

+ (instancetype)withActiveNodes:(NSArray<id<LHNode>> *)activeNodes routeHint:(LHRouteHint *)hint {
    return [[[self class] alloc] initWithActiveNodes:[NSSet setWithArray:activeNodes] inactiveNodes:nil routeHint:hint];
}

+ (instancetype)withActiveNodes:(NSArray<id<LHNode>> *)activeNodes routeNodes:(NSArray<id<LHNode>> *)routeNodes {
    LHRouteHint *hint = [LHRouteHint hintWithNodes:[NSOrderedSet orderedSetWithArray:routeNodes]];
    return [self withActiveNodes:activeNodes routeHint:hint];
}

+ (instancetype)withActiveNodes:(NSArray<id<LHNode>> *)activeNodes routeOrigin:(LHRouteHintOrigin)routeOrigin {
    return [self withActiveNodes:activeNodes routeHint:[LHRouteHint hintWithOrigin:routeOrigin]];
}

+ (instancetype)withActiveNodes:(NSArray<id<LHNode>> *)activeNodes {
    return [self withActiveNodes:activeNodes routeHint:nil];
}

+ (instancetype)withInactiveNode:(id<LHNode>)inactiveNode routeHint:(LHRouteHint *)hint {
    return [[[self class] alloc] initWithActiveNodes:nil inactiveNodes:[NSSet setWithObject:inactiveNode] routeHint:hint];
}

+ (instancetype)withInactiveNode:(id<LHNode>)inactiveNode routeNodes:(NSArray<id<LHNode>> *)routeNodes {
    LHRouteHint *hint = [LHRouteHint hintWithNodes:[NSOrderedSet orderedSetWithArray:routeNodes]];
    return [self withInactiveNode:inactiveNode routeHint:hint];
}

+ (instancetype)withInactiveNode:(id<LHNode>)inactiveNode routeOrigin:(LHRouteHintOrigin)routeOrigin {
    return [self withInactiveNode:inactiveNode routeOrigin:routeOrigin];
}

+ (instancetype)withInactiveNode:(id<LHNode>)inactiveNode {
    return [self withInactiveNode:inactiveNode routeHint:nil];
}

+ (instancetype)withInactiveNodes:(NSArray<id<LHNode>> *)inactiveNodes routeHint:(LHRouteHint *)hint {
    return [[[self class] alloc] initWithActiveNodes:nil inactiveNodes:[NSSet setWithArray:inactiveNodes] routeHint:hint];
}

+ (instancetype)withInactiveNodes:(NSArray<id<LHNode>> *)inactiveNodes routeNodes:(NSArray<id<LHNode>> *)routeNodes {
    LHRouteHint *hint = [LHRouteHint hintWithNodes:[NSOrderedSet orderedSetWithArray:routeNodes]];
    return [self withInactiveNodes:inactiveNodes routeHint:hint];
}

+ (instancetype)withInactiveNodes:(NSArray<id<LHNode>> *)inactiveNodes routeOrigin:(LHRouteHintOrigin)routeOrigin {
    return [self withInactiveNodes:inactiveNodes routeOrigin:routeOrigin];
}

+ (instancetype)withInactiveNodes:(NSArray<id<LHNode>> *)inactiveNodes {
    return [self withInactiveNodes:inactiveNodes routeHint:nil];
}

#pragma mark - NSObject

- (NSDictionary<NSString *,id> *)lh_debugProperties {
    return @{ @"activeNodes": self.activeNodes, @"inactiveNodes": self.inactiveNodes, @"routeHint": self.routeHint ?: [NSNull null] };
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
