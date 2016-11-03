//
//  LHGraphEdge.m
//  Lighthouse
//
//  Created by Makarov Yury on 03/11/2016.
//  Copyright © 2016 Joom. All rights reserved.
//

#import "LHGraphEdge.h"

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

#pragma mark - NSObject

- (BOOL)isEqual:(LHGraphEdge *)other {
    if (other == self) {
        return YES;
    } else if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    } else {
        return [self isEqualToEdge:other];
    }
}

- (BOOL)isEqualToEdge:(LHGraphEdge *)other {
    return [self.fromNode isEqual:other.fromNode] && [self.toNode isEqual:other.toNode];
}

- (NSUInteger)hash {
    NSUInteger prime = 31;
    NSUInteger result = 1;
    
    result = prime * result + [self.fromNode hash];
    result = prime * result + [self.toNode hash];
    
    return result;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithString:[super description]];
    [description appendString:@"  {\n"];
    if (self.label.length > 0) {
        [description appendFormat:@"  label: %@\n", self.label];
    }
    [description appendFormat:@"  from: %@\n", self.fromNode];
    [description appendFormat:@"  to: %@\n", self.toNode];
    [description appendString:@"}"];
    return [description copy];
}

@end
