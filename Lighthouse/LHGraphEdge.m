//
//  LHGraphEdge.m
//  Lighthouse
//
//  Created by Makarov Yury on 03/11/2016.
//  Copyright © 2016 Joom. All rights reserved.
//

#import "LHGraphEdge.h"
#import "LHDebugPrintable.h"

@interface LHGraphEdge () <LHDebugPrintable>

@end


@implementation LHGraphEdge

- (instancetype)initWithFromNode:(id)fromNode toNode:(id)toNode label:(NSString *)label {
    self = [super init];
    if (self) {
        _fromNode = fromNode;
        _toNode = toNode;
        _label = label;
    }
    return self;
}

- (instancetype)initWithFromNode:(id)fromNode toNode:(id)toNode {
    return [self initWithFromNode:fromNode toNode:toNode label:nil];
}

#pragma mark - LHDebugPrintable

- (NSDictionary<NSString *,id> *)lh_debugProperties {
    return @{ @"label": self.label ?: [NSNull null], @"fromNode": self.fromNode, @"toNode": self.toNode };
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
