//
//  RTRFreeStackNode.m
//  Router
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRFreeStackNode.h"
#import "RTRNodeTree.h"
#import "RTRStackNodeChildrenState.h"
#import "RTRTarget.h"

@interface RTRFreeStackNode ()

@property (nonatomic, copy, readonly) NSArray *trees;

@property (nonatomic, strong) NSArray *treeStack;
@property (nonatomic, strong) RTRStackNodeChildrenState *childrenState;

@property (nonatomic, strong) NSMapTable *nodeStackByTree;

@end


@implementation RTRFreeStackNode

#pragma mark - Init

- (instancetype)init {
    return [self initWithTrees:nil];
}

- (instancetype)initWithTrees:(NSArray *)trees {
    NSParameterAssert(trees.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    _trees = [trees copy];
    
    NSMutableSet *allChildren = [[NSMutableSet alloc] init];
    for (RTRNodeTree *tree in trees) {
        [allChildren unionSet:[tree allItems]];
    }
    _allChildren = [allChildren copy];
    
    [self resetChildrenState];
    
    return self;
}

#pragma mark - RTRNode

@synthesize allChildren = _allChildren;

- (RTRStackNodeChildrenState *)childrenState {
    if (!_childrenState) {
        NSMutableOrderedSet *stack = [[NSMutableOrderedSet alloc] init];
        
        for (RTRNodeTree *tree in self.treeStack) {
            [stack unionOrderedSet:[self.nodeStackByTree objectForKey:tree]];
        }
        
        _childrenState = [[RTRStackNodeChildrenState alloc] initWithStack:stack];
    }
    return _childrenState;
}

- (void)resetChildrenState {
    self.nodeStackByTree = [NSMapTable strongToStrongObjectsMapTable];
    
    for (RTRNodeTree *tree in self.trees) {
        id<RTRNode> firstNode = [tree nextItems:nil].firstObject;
        [self.nodeStackByTree setObject:[NSOrderedSet orderedSetWithObject:firstNode] forKey:tree];
    }
    
    self.treeStack = @[ self.trees.firstObject ];
    
    self.childrenState = nil;
}

- (BOOL)updateChildrenState:(RTRTarget *)target {
    id<RTRNode> activeChild = [self activeChildForTarget:target];
    if (!activeChild) {
        return NO;
    }
    
    RTRNodeTree *tree = [self treeForChild:activeChild];
    if (!tree) {
        return NO;
    }
    
    [self.nodeStackByTree setObject:[tree pathToItem:activeChild] forKey:tree];
    
    NSInteger treeStackIndex = [self.treeStack indexOfObject:tree];
    
    if (treeStackIndex != NSNotFound) {
        self.treeStack = [self.treeStack subarrayWithRange:NSMakeRange(0, treeStackIndex + 1)];
    } else {
        self.treeStack = [self.treeStack arrayByAddingObject:tree];
    }
    
    self.childrenState = nil;
    
    return YES;
}

#pragma mark - Stuff

- (id<RTRNode>)activeChildForTarget:(RTRTarget *)target {
    // TODO: don't copypaste this please
    
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

- (RTRNodeTree *)treeForChild:(id<RTRNode>)child {
    for (RTRNodeTree *tree in self.trees) {
        if ([[tree allItems] containsObject:child]) {
            return tree;
        }
    }
    
    return nil;
}

@end
