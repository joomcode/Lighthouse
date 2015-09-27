//
//  RTRStackNode.m
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRStackNode.h"
#import "RTRNodeTree.h"
#import "RTRNodeForest.h"
#import "RTRStackNodeChildrenState.h"
#import "RTRTargetNodes.h"

@interface RTRStackNode ()

@property (nonatomic, copy, readonly) RTRNodeForest *forest;
@property (nonatomic, strong, readonly) NSMapTable *initializedChildrenByTree;

@property (nonatomic, strong) RTRStackNodeChildrenState *childrenState;

@end


@implementation RTRStackNode

#pragma mark - Init

- (instancetype)init {
    return [self initWithForest:nil];
}

- (instancetype)initWithSingleBranch:(NSArray *)nodes {
    NSParameterAssert(nodes != nil);
    
    RTRNodeTree *tree = [[RTRNodeTree alloc] init];
    [tree addBranch:nodes afterItemOrNil:nil];
    
    return [self initWithTree:tree];
}

- (instancetype)initWithTree:(RTRNodeTree *)tree {
    NSParameterAssert(tree != nil);
    
    RTRNodeForest *forest = [[RTRNodeForest alloc] init];
    [forest addItem:tree afterItemOrNil:nil];
    
    return [self initWithForest:forest];
}

- (instancetype)initWithForest:(RTRNodeForest *)forest {
    NSParameterAssert(forest != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _forest = forest;
    _allChildren = [self collectChildrenFromForest:forest];
    
    _initializedChildrenByTree = [NSMapTable strongToStrongObjectsMapTable];
    
    [self resetChildrenState];
    
    return self;
}

- (NSSet *)collectChildrenFromForest:(RTRNodeForest *)forest {
    NSMutableSet *children = [[NSMutableSet alloc] init];
    
    for (RTRNodeTree *tree in [forest allItems]) {
        [children unionSet:[tree allItems]];
    }
    
    return [children copy];
}

#pragma mark - RTRNode

@synthesize allChildren = _allChildren;
@synthesize childrenState = _childrenState;

- (void)resetChildrenState {
    [self.initializedChildrenByTree removeAllObjects];
    [self.forest enumerateItemsWithBlock:^(RTRNodeTree *tree, id previousItem, BOOL *stop) {
        id<RTRNode> firstNode = [tree nextItems:nil].firstObject;
        [self.initializedChildrenByTree setObject:[NSOrderedSet orderedSetWithObject:firstNode] forKey:tree];
    }];
    
    RTRNodeTree *firstTree = [self.forest nextItems:nil].firstObject;
    self.childrenState = [[RTRStackNodeChildrenState alloc] initWithStack:[self nodePathToTree:firstTree]];
}

- (BOOL)updateChildrenState:(RTRTargetNodes *)targetNodes {
    id<RTRNode> targetNode = [self targetChildForNodes:targetNodes];
    if (!targetNode) {
        return NO;
    }
    
    RTRNodeTree *targetTree = [self treeForNode:targetNode];
    if (!targetTree) {
        return NO;
    }
    
    [self.initializedChildrenByTree setObject:[targetTree pathToItem:targetNode] forKey:targetTree];

    self.childrenState = [[RTRStackNodeChildrenState alloc] initWithStack:[self nodePathToTree:targetTree]];
    
    return YES;
}

#pragma mark - Stuff

- (id<RTRNode>)targetChildForNodes:(RTRTargetNodes *)targetNodes {
    if (targetNodes.activeNodes.count > 1) {
        NSAssert(NO, nil); // TODO
        return nil;
    }
    
    id<RTRNode> result = targetNodes.activeNodes.anyObject;
    
    if ([targetNodes.inactiveNodes containsObject:self.childrenState.initializedChildren.lastObject]) {
        for (id<RTRNode> node in [self.childrenState.initializedChildren reverseObjectEnumerator]) {
            if ([targetNodes.inactiveNodes containsObject:node]) {
                continue;
            }

            if (result && result != node) {
                NSAssert(NO, nil); // TODO
                return nil;
            } else {
                return node;
            }
        }
    }
    
    return result;
}

- (RTRNodeTree *)treeForNode:(id<RTRNode>)node {
    for (RTRNodeTree *tree in [self.forest allItems]) {
        if ([[tree allItems] containsObject:node]) {
            return tree;
        }
    }
    
    return nil;
}

- (NSOrderedSet *)nodePathToTree:(RTRNodeTree *)targetTree {
    NSMutableOrderedSet *path = [[NSMutableOrderedSet alloc] init];
    
    for (RTRNodeTree *tree in [self.forest pathToItem:targetTree]) {
        [path unionOrderedSet:[self.initializedChildrenByTree objectForKey:tree]];
    }
    
    return path;
}

@end
