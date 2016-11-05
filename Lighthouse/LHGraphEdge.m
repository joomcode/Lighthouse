//
//  LHGraphEdge.m
//  Lighthouse
//
//  Created by Makarov Yury on 03/11/2016.
//  Copyright © 2016 Joom. All rights reserved.
//

#import "LHGraphEdge.h"
#import "LHDebugDescription.h"

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
    if (self.label.length > 0) {
        result = prime * result + [self.label hash];
    }
    return result;
}

#pragma mark - LHDebugPrintable

- (NSString *)lh_descriptionWithIndent:(NSUInteger)indent {
    return [self lh_descriptionWithIndent:indent block:^(NSMutableString *buffer, NSString *indentString, NSUInteger indent) {
        if (self.label.length > 0) {
            [buffer appendFormat:@"%@label = %@\n", indentString, self.label];
        }
        [buffer appendFormat:@"%@fromNode = %@\n", indentString, [self.fromNode lh_descriptionWithIndent:indent]];
        [buffer appendFormat:@"%@toNode = %@\n", indentString, [self.toNode lh_descriptionWithIndent:indent]];
    }];
}

- (NSString *)description {
    return [self lh_descriptionWithIndent:0];
}

@end
