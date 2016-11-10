//
//  LHRouteHint.m
//  Lighthouse
//
//  Created by Makarov Yury on 04/11/2016.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHRouteHint.h"
#import "LHDebugPrintable.h"

@interface LHRouteHint () <LHDebugPrintable>

@end


@implementation LHRouteHint

- (instancetype)initWithNodes:(NSOrderedSet<id<LHNode>> *)nodes
                        edges:(NSOrderedSet<LHGraphEdge<id<LHNode>> *> *)edges
                       origin:(LHRouteHintOrigin)origin {
    self = [super init];
    if (self) {
        _nodes = nodes;
        _edges = edges;
        _origin = origin;
    }
    return self;
}

- (instancetype)init {
    return [self initWithNodes:nil edges:nil origin:LHRouteHintOriginRoot];
}

+ (LHRouteHint *)hintWithNodes:(NSOrderedSet<id<LHNode>> *)nodes {
    return [[LHRouteHint alloc] initWithNodes:nodes edges:nil origin:LHRouteHintOriginRoot];
}

+ (LHRouteHint *)hintWithEdges:(NSOrderedSet<LHGraphEdge<id<LHNode>> *> *)edges {
    return [[LHRouteHint alloc] initWithNodes:nil edges:edges origin:LHRouteHintOriginRoot];
}

+ (LHRouteHint *)hintWithNodes:(NSOrderedSet<id<LHNode>> *)nodes edges:(NSOrderedSet<LHGraphEdge<id<LHNode>> *> *)edges {
    return [[LHRouteHint alloc] initWithNodes:nodes edges:edges origin:LHRouteHintOriginRoot];
}

+ (LHRouteHint *)hintWithOrigin:(LHRouteHintOrigin)origin {
    return [[LHRouteHint alloc] initWithNodes:nil edges:nil origin:origin];
}

#pragma mark - LHDebugPrintable

- (NSDictionary<NSString *,id> *)lh_debugProperties {
    return @{ @"nodes": self.nodes ?: [NSNull null], @"edges": self.edges ?: [NSNull null],
              @"origin": self.origin == LHRouteHintOriginRoot ? @"root" : @"active node" };
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
