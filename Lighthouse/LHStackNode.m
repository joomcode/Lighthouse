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
#import "LHNodeHelpers.h"

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

- (instancetype)initWithTreeBlock:(void (^)(LHNodeTree *tree))treeBlock {
    LHNodeTree *tree = [[LHNodeTree alloc] init];
    treeBlock(tree);
    
    return [self initWithTree:tree];
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
    BOOL error = NO;
    id<LHNode> activeChild = [LHNodeHelpers activeChildForApplyingTarget:target
                                                           toActiveStack:self.childrenState.initializedChildren
                                                                   error:&error];
    
    if (!activeChild) {
        return NO;
    }
    
    self.childrenState = [[LHStackNodeChildrenState alloc] initWithStack:[self.tree pathToItem:activeChild]];
    
    return YES;
}

@end
