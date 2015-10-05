//
//  RTRStackNode.m
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRStackNode.h"
#import "RTRNodeTree.h"
#import "RTRStackNodeChildrenState.h"
#import "RTRTarget.h"

@interface RTRStackNode ()

@property (nonatomic, copy, readonly) RTRNodeTree *tree;

@property (nonatomic, strong) RTRStackNodeChildrenState *childrenState;

@end


@implementation RTRStackNode

#pragma mark - Init

- (instancetype)init {
    return [self initWithTree:nil];
}

- (instancetype)initWithSingleBranch:(NSArray *)nodes {
    NSParameterAssert(nodes != nil);
    
    RTRNodeTree *tree = [[RTRNodeTree alloc] init];
    [tree addBranch:nodes afterItemOrNil:nil];
    
    return [self initWithTree:tree];
}

- (instancetype)initWithTree:(RTRNodeTree *)tree {
    NSParameterAssert(tree != nil);
    
    self = [super init];
    if (!self) return nil;

    _tree = tree;
    
    [self resetChildrenState];
    
    return self;
}

#pragma mark - RTRNode

@synthesize childrenState = _childrenState;

- (NSSet *)allChildren {
    return [self.tree allItems];
}

- (void)resetChildrenState {
    id<RTRNode> firstChild = [self.tree nextItems:nil].firstObject;
    self.childrenState = [[RTRStackNodeChildrenState alloc] initWithStack:[NSOrderedSet orderedSetWithObject:firstChild]];
}

- (BOOL)updateChildrenState:(RTRTarget *)target {
    id<RTRNode> activeChild = [self activeChildForTarget:target];
    if (!activeChild) {
        return NO;
    }
    
    self.childrenState = [[RTRStackNodeChildrenState alloc] initWithStack:[self.tree pathToItem:activeChild]];
    
    return YES;
}

#pragma mark - Stuff

- (id<RTRNode>)activeChildForTarget:(RTRTarget *)target {
    if (target.activeNodes.count > 1) {
        NSAssert(NO, nil); // TODO
        return nil;
    }
    
    id<RTRNode> childForTargetActiveNodes = target.activeNodes.anyObject;
    
    id<RTRNode> childForTargetInactiveNodes;
    
    for (id<RTRNode> node in [self.childrenState.initializedChildren reverseObjectEnumerator]) {
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
