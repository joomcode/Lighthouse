//
//  LHLeafNode.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHLeafNode.h"

@implementation LHLeafNode

#pragma mark - LHNode

- (NSSet<id<LHNode>> *)allChildren {
    return nil;
}

- (id<LHNodeChildrenState>)childrenState {
    return nil;
}

- (void)resetChildrenState {
}

- (BOOL)updateChildrenState:(id<LHTarget>)target {
    return NO;
}

@end
