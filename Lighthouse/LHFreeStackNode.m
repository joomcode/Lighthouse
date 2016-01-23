//
//  LHFreeStackNode.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHFreeStackNode.h"
#import "LHNodeTree.h"
#import "LHStackNodeChildrenState.h"
#import "LHTarget.h"
#import "LHNodeHelpers.h"

@interface LHFreeStackNode ()

@property (nonatomic, copy, readonly) NSArray<LHNodeTree *> *trees;

@property (nonatomic, strong) NSArray<LHNodeTree *> *treeStack;
@property (nonatomic, strong) LHStackNodeChildrenState *childrenState;

@property (nonatomic, strong) NSMapTable<LHNodeTree *, NSOrderedSet<id<LHNode>> *> *nodeStackByTree;

@end


@implementation LHFreeStackNode

#pragma mark - Init

- (instancetype)initWithTrees:(NSArray<LHNodeTree *> *)trees {
    NSParameterAssert(trees.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    _trees = [trees copy];
    
    NSMutableSet<id<LHNode>> *allChildren = [[NSMutableSet alloc] init];
    for (LHNodeTree *tree in trees) {
        [allChildren unionSet:[tree allItems]];
    }
    _allChildren = [allChildren copy];
    
    [self resetChildrenState];
    
    return self;
}

#pragma mark - LHNode

@synthesize allChildren = _allChildren;

- (LHStackNodeChildrenState *)childrenState {
    if (!_childrenState) {
        NSMutableOrderedSet *stack = [[NSMutableOrderedSet alloc] init];
        
        for (LHNodeTree *tree in self.treeStack) {
            [stack unionOrderedSet:[self.nodeStackByTree objectForKey:tree]];
        }
        
        _childrenState = [[LHStackNodeChildrenState alloc] initWithStack:stack];
    }
    return _childrenState;
}

- (void)resetChildrenState {
    self.nodeStackByTree = [NSMapTable strongToStrongObjectsMapTable];
    
    for (LHNodeTree *tree in self.trees) {
        id<LHNode> firstNode = [tree nextItems:nil].firstObject;
        [self.nodeStackByTree setObject:[NSOrderedSet orderedSetWithObject:firstNode] forKey:tree];
    }
    
    self.treeStack = @[ self.trees.firstObject ];
    
    self.childrenState = nil;
}

- (BOOL)updateChildrenState:(id<LHTarget>)target {
    BOOL error = NO;
    id<LHNode> activeChild = [LHNodeHelpers activeChildForApplyingTarget:target
                                                           toActiveStack:self.childrenState.initializedChildren
                                                                   error:&error];
    
    if (!activeChild) {
        return NO;
    }
    
    LHNodeTree *tree = [self treeForChild:activeChild];
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

- (LHNodeTree *)treeForChild:(id<LHNode>)child {
    for (LHNodeTree *tree in self.trees) {
        if ([[tree allItems] containsObject:child]) {
            return tree;
        }
    }
    
    return nil;
}

@end
