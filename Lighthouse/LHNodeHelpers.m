//
//  LHNodeHelpers.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 23/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHNodeHelpers.h"
#import "LHNode.h"
#import "LHTarget.h"

@implementation LHNodeHelpers

+ (nullable id<LHNode>)activeChildForApplyingTarget:(id<LHTarget>)target
                                      toActiveStack:(NSOrderedSet<id<LHNode>> *)activeStack
                                              error:(BOOL *)error {
    if (target.activeNodes.count > 1) {
        if (error) {
            *error = YES;
        }
        return nil;
    }
    
    id<LHNode> childForTargetActiveNodes = target.activeNodes.anyObject;
    
    id<LHNode> childForTargetInactiveNodes = nil;
    
    for (id<LHNode> node in [activeStack reverseObjectEnumerator]) {
        if (![target.inactiveNodes containsObject:node]) {
            if (node != activeStack.lastObject) {
                childForTargetInactiveNodes = node;
            }
            break;
        }
    }
    
    if (childForTargetActiveNodes && childForTargetInactiveNodes && childForTargetActiveNodes != childForTargetInactiveNodes) {
        if (error) {
            *error = YES;
        }
        return nil;
    }
    
    return childForTargetActiveNodes ?: childForTargetInactiveNodes;
}

@end
