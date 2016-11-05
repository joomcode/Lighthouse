//
//  LHRouteHint.m
//  Lighthouse
//
//  Created by Makarov Yury on 04/11/2016.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHRouteHint.h"
#import "LHDebugDescription.h"

@implementation LHRouteHint

- (instancetype)initWithNodes:(NSOrderedSet<id<LHNode>> *)nodes edges:(NSOrderedSet<LHGraphEdge<id<LHNode>> *> *)edges {
    self = [super init];
    if (self) {
        _nodes = nodes;
        _edges = edges;
    }
    return self;
}

- (instancetype)init {
    return [self initWithNodes:nil edges:nil];
}

+ (LHRouteHint *)hintWithNodes:(NSOrderedSet<id<LHNode>> *)nodes {
    return [[LHRouteHint alloc] initWithNodes:nodes edges:nil];
}

+ (LHRouteHint *)hintWithEdges:(NSOrderedSet<LHGraphEdge<id<LHNode>> *> *)edges {
    return [[LHRouteHint alloc] initWithNodes:nil edges:edges];
}

+ (LHRouteHint *)hintWithNodes:(NSOrderedSet<id<LHNode>> *)nodes edges:(NSOrderedSet<LHGraphEdge<id<LHNode>> *> *)edges {
    return [[LHRouteHint alloc] initWithNodes:nodes edges:edges];
}

#pragma mark - LHDebugPrintable

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    return [self lh_descriptionWithIndent:indent block:^(NSMutableString *buffer, NSString *indentString, NSUInteger indent) {
        [buffer appendFormat:@"%@nodes = %@\n", indentString, [self.nodes lh_descriptionWithIndent:indent]];
        [buffer appendFormat:@"%@edges = %@\n", indentString, [self.edges lh_descriptionWithIndent:indent]];
    }];
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
