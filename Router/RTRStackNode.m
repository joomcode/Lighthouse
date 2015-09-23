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

@interface RTRStackNode ()

@property (nonatomic, copy, readonly) RTRNodeForest *forest;

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
    RTRNodeTree *firstTree = [self.forest nextItems:nil].firstObject;
    id<RTRNode> firstNode = [firstTree nextItems:nil].firstObject;
    
    NSOrderedSet *initializedChildren = [NSOrderedSet orderedSetWithObject:firstNode];
    
    NSMapTable *initializedChildrenByTree = [NSMapTable strongToStrongObjectsMapTable];
    [initializedChildrenByTree setObject:initializedChildren forKey:firstTree];
    
    self.childrenState = [[RTRStackNodeChildrenState alloc] initWithInitializedChildren:initializedChildren
                                                              initializedChildrenByTree:initializedChildrenByTree];
}

- (BOOL)activateChildren:(NSSet *)children {
    NSAssert(children.count == 1, @""); // TODO
    id<RTRNode> targetNode = children.anyObject;
    
    RTRNodeTree *targetTree = [self treeForNode:targetNode];
    if (!targetTree) {
        return NO;
    }
    
    NSMapTable *initializedChildrenByTree = [self.childrenState.initializedChildrenByTree copy];
    [initializedChildrenByTree setObject:[targetTree pathToItem:targetNode] forKey:targetTree];
    
    NSOrderedSet *path = [self nodePathToTree:targetTree initializedChildrenByTree:initializedChildrenByTree];
    
    self.childrenState = [[RTRStackNodeChildrenState alloc] initWithInitializedChildren:path
                                                              initializedChildrenByTree:initializedChildrenByTree];
    
    return YES;
}

#pragma mark - Stuff

- (RTRNodeTree *)treeForNode:(id<RTRNode>)node {
    for (RTRNodeTree *tree in [self.forest allItems]) {
        if ([[tree allItems] containsObject:node]) {
            return tree;
        }
    }
    
    return nil;
}

- (NSOrderedSet *)nodePathToTree:(RTRNodeTree *)targetTree initializedChildrenByTree:(NSMapTable *)initializedChildrenByTree {
    NSMutableOrderedSet *path = [[NSMutableOrderedSet alloc] init];
    
    for (RTRNodeTree *tree in [self.forest pathToItem:targetTree]) {
        NSOrderedSet *initializedChildren = [initializedChildrenByTree objectForKey:tree];
        if (!initializedChildren) {
            initializedChildren = [NSOrderedSet orderedSetWithObject:[tree nextItems:nil].firstObject];
            [initializedChildrenByTree setObject:initializedChildren forKey:tree];
        }
        
        [path unionOrderedSet:initializedChildren];
    }
    
    return path;
}

@end
