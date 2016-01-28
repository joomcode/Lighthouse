//
//  LHTabBarControllerDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHTabBarControllerDriver.h"
#import "LHTabNode.h"
#import "LHDriverChannel.h"
#import "LHDriverUpdateContext.h"
#import "LHTarget.h"
#import "LHViewControllerDriverHelpers.h"
#import "LHNodeHelpers.h"

@interface LHTabBarControllerDriver () <UITabBarControllerDelegate>

@property (nonatomic, strong, readonly) LHTabNode *node;
@property (nonatomic, strong, readonly) id<LHDriverChannel> channel;

@property (nonatomic, strong, readonly) NSMapTable<id<LHNode>, UITabBarItem *> *tabBarItems;
@property (nonatomic, strong, readonly) NSMutableSet<id<LHNode>> *tabBarItemBoundNodes;

@end


@implementation LHTabBarControllerDriver

#pragma mark - Init

- (instancetype)initWithNode:(LHTabNode *)node channel:(id<LHDriverChannel>)channel {
    self = [super init];
    if (!self) return nil;
    
    _node = node;
    _channel = channel;
    
    _tabBarItems = [NSMapTable strongToStrongObjectsMapTable];
    _tabBarItemBoundNodes = [NSMutableSet set];
    
    return self;
}

#pragma mark - Dealloc

- (void)dealloc {
    _data.delegate = nil;
}

#pragma mark - Public

- (void)bindChildNode:(id<LHNode>)childNode toTabBarItem:(UITabBarItem *)tabBarItem {
    [self.tabBarItems setObject:tabBarItem forKey:childNode];
    [self.tabBarItemBoundNodes addObject:childNode];
}

#pragma mark - Helpers

- (UITabBarItem *)tabBarItemForNode:(id<LHNode>)node {
    NSSet<id<LHNode>> *nodeDescendants = [LHNodeHelpers allDescendantsOfNode:node];
    
    NSMutableSet *candidateNodes = [self.tabBarItemBoundNodes mutableCopy];
    [candidateNodes intersectSet:nodeDescendants];

    if (candidateNodes.count > 1) {
        // TODO: assert?
        return nil;
    }
    
    return candidateNodes.count == 1 ? [self.tabBarItems objectForKey:candidateNodes.anyObject] : nil;
}

- (NSArray<UIViewController *> *)childViewControllersForUpdateContext:(id<LHDriverUpdateContext>)context {
    NSSet<UIViewController *> *oldChildViewControllers = [NSSet setWithArray:self.data.viewControllers ?: @[]];
    
    NSArray<UIViewController *> *childViewControllers =
        [LHViewControllerDriverHelpers viewControllersForNodes:self.node.orderedChildren withUpdateContext:context];
    
    [childViewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        if ([oldChildViewControllers containsObject:viewController]) {
            return;
        }

        // This viewController is new, let's see if we have a tabBarItem for it.
        
        id<LHNode> childNode = self.node.orderedChildren[idx];
        UITabBarItem *tabBarItem = [self tabBarItemForNode:childNode];
        
        if (tabBarItem) {
            viewController.tabBarItem = tabBarItem;
        }
    }];
    
    return childViewControllers;
}

#pragma mark - LHDriver

@synthesize data = _data;

- (UITabBarController *)data {
    if (!_data) {
        _data = [[UITabBarController alloc] init];
        _data.delegate = self;
    }
    return _data;
}

- (void)updateWithContext:(id<LHDriverUpdateContext>)context {
    NSArray<UIViewController *> *childViewControllers = [self childViewControllersForUpdateContext:context];
    
    if (![childViewControllers isEqualToArray:self.data.viewControllers]) {
        [self.data setViewControllers:childViewControllers animated:context.animated]; // TODO: use updateQueue for animated update
    }
    
    if (self.data.selectedIndex != self.node.childrenState.activeChildIndex) {
        [self.data setSelectedIndex:self.node.childrenState.activeChildIndex];
    }
}

- (void)presentationStateDidChange:(LHNodePresentationState)presentationState {
}

#pragma mark - UITabBarBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [self.channel startNodeUpdateWithBlock:^(id<LHNode> node) {
        NSUInteger activeChildIndex = [tabBarController.viewControllers indexOfObject:viewController];
        id<LHNode> activeChild = self.node.orderedChildren[activeChildIndex];
        
        [node updateChildrenState:[LHTarget withActiveNode:activeChild]];
    }];
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self.channel finishNodeUpdate];
}

@end
