//
//  LHStackNode.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHStackNode.h"
#import "LHNodeTree.h"
#import "LHStackNodeChildrenState.h"
#import "LHTarget.h"

@interface LHStackNode ()

@property (nonatomic, copy, readonly) LHNodeTree *tree;

@property (nonatomic, strong) LHStackNodeChildrenState *childrenState;

@end


@implementation LHStackNode

#pragma mark - Init

- (instancetype)initWithSingleBranch:(NSArray<id<LHNode>> *)nodes {
    NSParameterAssert(nodes.count > 0);
    
    LHNodeTree *tree = [[LHNodeTree alloc] init];
    [tree addBranch:nodes afterItemOrNil:nil];
    
    return [self initWithTree:tree];
}

- (instancetype)initWithTree:(LHNodeTree *)tree {
    self = [super init];
    if (!self) return nil;

    _tree = tree;
    
    [self resetChildrenState];
    
    return self;
}

#pragma mark - LHNode

@synthesize childrenState = _childrenState;

- (NSSet<id<LHNode>> *)allChildren {
    return [self.tree allItems];
}

- (void)resetChildrenState {
    id<LHNode> firstChild = [self.tree nextItems:nil].firstObject;
    self.childrenState = [[LHStackNodeChildrenState alloc] initWithStack:[NSOrderedSet orderedSetWithObject:firstChild]];
}

- (BOOL)updateChildrenState:(id<LHTarget>)target {
    id<LHNode> activeChild = [self activeChildForTarget:target];
    if (!activeChild) {
        return NO;
    }
    
    self.childrenState = [[LHStackNodeChildrenState alloc] initWithStack:[self.tree pathToItem:activeChild]];
    
    return YES;
}

#pragma mark - Stuff

- (id<LHNode>)activeChildForTarget:(id<LHTarget>)target {
    if (target.activeNodes.count > 1) {
        NSAssert(NO, nil); // TODO
        return nil;
    }
    
    id<LHNode> childForTargetActiveNodes = target.activeNodes.anyObject;
    
    id<LHNode> childForTargetInactiveNodes;
    
    for (id<LHNode> node in [self.childrenState.initializedChildren reverseObjectEnumerator]) {
        if (![target.inactiveNodes containsObject:node]) {
            if (node != self.childrenState.initializedChildren.lastObject) {
                childForTargetInactiveNodes = node;
            }
            break;
        }
    }
    
    if (childForTargetActiveNodes && childForTargetInactiveNodes && childForTargetActiveNodes != childForTargetInactiveNodes) {
        NSAssert(NO, nil); // TODO
        return nil;
    }
    
    return childForTargetActiveNodes ?: childForTargetInactiveNodes;
}

@end
