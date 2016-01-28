//
//  LHNodeHelpers.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 28/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHNodeHelpers.h"
#import "LHNode.h"

@implementation LHNodeHelpers

#pragma mark - Public

+ (NSSet<id<LHNode>> *)allDescendantsOfNode:(id<LHNode>)node {
    NSMutableSet<id<LHNode>> *set = [NSMutableSet setWithObject:node];
    [self collectDescendantsOfNode:node toSet:set];
    return set;
}

#pragma mark - Private

+ (void)collectDescendantsOfNode:(id<LHNode>)node toSet:(NSMutableSet<id<LHNode>> *)set {
    NSSet<id<LHNode>> *nodeChildren = [node allChildren];
    
    [set unionSet:nodeChildren];
    
    for (id<LHNode> child in nodeChildren) {
        [self collectDescendantsOfNode:child toSet:set];
    }
}

@end
