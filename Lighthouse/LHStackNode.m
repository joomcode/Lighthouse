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

@property (nonatomic, copy, readonly) NSArray<LHNodeTree *> *trees;

@property (nonatomic, strong) LHStackNodeChildrenState *childrenState;
@property (nonatomic, strong) NSArray<LHNodeTree *> *activeTrees;

@property (nonatomic, strong) NSMapTable<LHNodeTree *, NSOrderedSet<id<LHNode>> *> *nodeStackByTree;

@end


@implementation LHStackNode

@synthesize label = _label;

#pragma mark - Init

- (instancetype)initWithSingleBranch:(NSArray<id<LHNode>> *)nodes label:(NSString *)label {
    NSParameterAssert(nodes.count > 0);
    
    LHNodeTree *tree = [[LHNodeTree alloc] init];
    [tree addBranch:nodes afterItemOrNil:nil];
    
    return [self initWithTree:tree label:label];
}

- (instancetype)initWithTree:(LHNodeTree *)tree label:(NSString *)label {
    NSParameterAssert(tree.allItems.count > 0);
    
    return [self initWithTrees:@[ tree ] label:label];
}

- (instancetype)initWithTreeBlock:(void (^)(LHNodeTree *tree))treeBlock label:(NSString *)label {
    LHNodeTree *tree = [[LHNodeTree alloc] init];
    treeBlock(tree);
    
    return [self initWithTree:tree label:label];
}

- (instancetype)initWithTrees:(NSArray<LHNodeTree *> *)trees label:(NSString *)label {
    NSParameterAssert(trees.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    _trees = [trees copy];
    _label = label;
    
    _allChildren = [self collectAllChildrenFromTrees:_trees];
    
    [self resetChildrenState];
    
    return self;    
}

- (NSSet *)collectAllChildrenFromTrees:(NSArray<LHNodeTree *> *)trees {
    NSMutableSet<id<LHNode>> *allChildren = [[NSMutableSet alloc] init];
    for (LHNodeTree *tree in trees) {
        [allChildren unionSet:tree.allItems];
    }
    return allChildren;
}

#pragma mark - LHNode

@synthesize allChildren = _allChildren;

- (void)resetChildrenState {
    self.nodeStackByTree = [NSMapTable strongToStrongObjectsMapTable];
    
    for (LHNodeTree *tree in self.trees) {
        id<LHNode> firstNode = [tree nextItems:nil].firstObject;
        [self.nodeStackByTree setObject:[NSOrderedSet orderedSetWithObject:firstNode] forKey:tree];
    }
    
    self.activeTrees = @[ self.trees.firstObject ];
    [self doUpdateChildrenState];
}

- (LHNodeUpdateResult)updateChildrenState:(LHTarget *)target {
    BOOL error = NO;
    
    id<LHNode> activeChild = [self activeChildForApplyingTarget:target
                                          toActiveChildrenStack:self.childrenState.stack
                                                          error:&error];
    
    if (error) {
        return LHNodeUpdateResultInvalid;
    }
    
    if (!activeChild) {
        return LHNodeUpdateResultDeactivation;
    }
    
    LHNodeTree *tree = [self treeForChild:activeChild];
    if (!tree) {
        return LHNodeUpdateResultInvalid;
    }
    
    [self.nodeStackByTree setObject:[tree pathToItem:activeChild] forKey:tree];
    
    [self activateTree:tree];
    [self doUpdateChildrenState];
    
    return LHNodeUpdateResultNormal;
}

#pragma mark - Stuff

- (id<LHNode>)activeChildForApplyingTarget:(LHTarget *)target
                     toActiveChildrenStack:(NSOrderedSet<id<LHNode>> *)activeChildrenStack
                                     error:(BOOL *)error {
    if (target.activeNodes.count > 1) {
        if (error) {
            *error = YES;
        }
        return nil;
    }
    
    id<LHNode> childForTargetActiveNodes = target.activeNodes.anyObject;
    
    id<LHNode> childForTargetInactiveNodes = nil;
    
    for (id<LHNode> node in [activeChildrenStack reverseObjectEnumerator]) {
        if (![target.inactiveNodes containsObject:node]) {
            if (node != activeChildrenStack.lastObject) {
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

- (LHNodeTree *)treeForChild:(id<LHNode>)child {
    for (LHNodeTree *tree in self.trees) {
        if ([tree.allItems containsObject:child]) {
            return tree;
        }
    }
    
    return nil;
}

- (void)activateTree:(LHNodeTree *)tree {
    NSInteger activeTreesIndex = [self.activeTrees indexOfObject:tree];
    
    if (activeTreesIndex != NSNotFound) {
        self.activeTrees = [self.activeTrees subarrayWithRange:NSMakeRange(0, activeTreesIndex + 1)];
    } else {
        self.activeTrees = [self.activeTrees arrayByAddingObject:tree];
    }
}

- (void)doUpdateChildrenState {
    NSMutableOrderedSet *stack = [[NSMutableOrderedSet alloc] init];
    
    for (LHNodeTree *tree in self.activeTrees) {
        [stack unionOrderedSet:[self.nodeStackByTree objectForKey:tree]];
    }
    
    self.childrenState = [[LHStackNodeChildrenState alloc] initWithStack:stack];
}

#pragma mark - NSObject

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithString:[super description]];
    [description appendString:@"{\n"];
    [description appendFormat:@"   childrenState: %@\n", self.childrenState];
    [description appendString:@"}"];
    return [description copy];
}

@end
