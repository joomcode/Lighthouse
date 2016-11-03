//
//  LHLeafNode.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHLeafNode.h"
#import "LHTarget.h"

@implementation LHLeafNode

@synthesize label = _label;

- (instancetype)initWithLabel:(NSString *)label {
    self = [super init];
    if (self) {
        _label = label;
    }
    return self;
}

#pragma mark - LHNode

- (NSSet<id<LHNode>> *)allChildren {
    return nil;
}

- (id<LHNodeChildrenState>)childrenState {
    return nil;
}

- (void)resetChildrenState {
}

- (LHNodeUpdateResult)updateChildrenState:(LHTarget *)target {
    if (target.activeNodes.count > 0 || target.inactiveNodes.count > 0) {
        return LHNodeUpdateResultInvalid;
    }
    
    return LHNodeUpdateResultNormal;
}

#pragma mark - NSObject

- (NSString *)description {
    return self.label;
}

@end
