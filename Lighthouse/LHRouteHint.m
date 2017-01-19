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
                       origin:(LHRouteHintOrigin)origin {
    self = [super init];
    if (self) {
        _nodes = nodes;
        _origin = origin;
    }
    return self;
}

- (instancetype)init {
    return [self initWithNodes:nil origin:LHRouteHintOriginRoot];
}

+ (LHRouteHint *)hintWithNodes:(NSOrderedSet<id<LHNode>> *)nodes {
    return [[LHRouteHint alloc] initWithNodes:nodes origin:LHRouteHintOriginRoot];
}

+ (LHRouteHint *)hintWithOrigin:(LHRouteHintOrigin)origin {
    return [[LHRouteHint alloc] initWithNodes:nil origin:origin];
}

#pragma mark - LHDebugPrintable

- (NSDictionary<NSString *,id> *)lh_debugProperties {
    return @{ @"nodes": self.nodes ?: [NSNull null],
              @"origin": self.origin == LHRouteHintOriginRoot ? @"root" : @"active node" };
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
