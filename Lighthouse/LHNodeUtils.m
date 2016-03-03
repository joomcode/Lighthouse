//
//  LHNodeUtils.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 03/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHNodeUtils.h"
#import "LHNode.h"
#import "LHNodeChildrenState.h"

@implementation LHNodeUtils

#pragma mark - Public

+ (LHNodeModelState)node:(id<LHNode>)node modelStateForChild:(id<LHNode>)childNode {
    if ([node.childrenState.inactiveChildren containsObject:childNode]) {
        return LHNodeModelStateInactive;
    }
    
    if ([node.childrenState.activeChildren containsObject:childNode]) {
        return LHNodeModelStateActive;
    }
    
    return LHNodeModelStateNotInitialized;
}

+ (void)enumerateChildrenOfNode:(id<LHNode>)node withBlock:(void (^)(id<LHNode> childNode, LHNodeModelState childModelState))block {
    NSMutableSet<id<LHNode>> *allChildren = [node.allChildren mutableCopy];
    [allChildren minusSet:node.childrenState.inactiveChildren];
    [allChildren minusSet:node.childrenState.activeChildren];
    
    for (id<LHNode> childNode in allChildren) {
        block(childNode, LHNodeModelStateNotInitialized);
    }
    
    for (id<LHNode> childNode in node.childrenState.inactiveChildren) {
        block(childNode, LHNodeModelStateInactive);
    }
    
    for (id<LHNode> childNode in node.childrenState.activeChildren) {
        block(childNode, LHNodeModelStateActive);
    }
}

@end
