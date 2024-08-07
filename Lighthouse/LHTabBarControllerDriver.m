//
//  LHTabBarControllerDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHTabBarControllerDriver.h"
#import "LHTabNode.h"
#import "LHDriverTools.h"
#import "LHDriverChannel.h"
#import "LHDriverUpdateContext.h"
#import "LHTaskQueue.h"
#import "LHTarget.h"
#import "LHNodeTree.h"
#import "LHViewControllerDriverHelpers.h"
#import "LHContainerTransitionStyleRegistry.h"
#import "LHContainerTransitionData.h"
#import "UIViewController+LHNavigationItemForwarding.h"

@interface LHTabBarControllerDriver ()

@property (nonatomic, strong, readonly) LHTabNode *node;
@property (nonatomic, strong, readonly) LHDriverTools *tools;

@property (nonatomic, strong, readonly) NSMapTable<id<LHNode>, UITabBarItem *> *tabBarItems;
@property (nonatomic, strong, readonly) NSMutableSet<id<LHNode>> *tabBarItemBoundNodes;

@property (nonatomic, strong) LHContainerTransitionData *currentTransitionData;

@end


@implementation LHTabBarControllerDriver

#pragma mark - Init

- (instancetype)initWithNode:(LHTabNode *)node tools:(LHDriverTools *)tools {
    self = [super init];
    if (!self) return nil;
    
    _node = node;
    _tools = tools;
    
    _tabBarItems = [NSMapTable strongToStrongObjectsMapTable];
    _tabBarItemBoundNodes = [NSMutableSet set];
    
    return self;
}

#pragma mark - Dealloc

- (void)dealloc {
    _data.delegate = nil;
}

#pragma mark - Public

- (LHContainerTransitionStyleRegistry *)transitionStyleRegistry {
    if (!_transitionStyleRegistry) {
        _transitionStyleRegistry = [[LHContainerTransitionStyleRegistry alloc] init];
    }
    return _transitionStyleRegistry;
}

- (void)bindDescendantNode:(id<LHNode>)descendantNode toTabBarItem:(UITabBarItem *)tabBarItem {
    [self.tabBarItems setObject:tabBarItem forKey:descendantNode];
    [self.tabBarItemBoundNodes addObject:descendantNode];
}

#pragma mark - Subclassing

- (UITabBarController *)loadData {
    return [[UITabBarController alloc] init];
}

#pragma mark - LHDriver

@synthesize data = _data;

- (UITabBarController *)data {
    if (!_data) {
        _data = [self loadData];
        _data.delegate = self;
    }
    return _data;
}

- (void)updateWithContext:(LHDriverUpdateContext *)context {
    [context.updateQueue runAsyncTaskWithBlock:^(LHTaskCompletionBlock completion) {
        NSArray<UIViewController *> *childViewControllers = [self childViewControllersForUpdateContext:context];
        UIViewController *oldSelectedViewController = self.data.selectedViewController;
        
        if (![childViewControllers isEqualToArray:self.data.viewControllers]) {
            [self.data setViewControllers:childViewControllers animated:context.animated];
        }
        
        [self updateForSelectedViewController:self.data.viewControllers[self.node.childrenState.activeChildIndex]];
        
        if (self.data.selectedIndex != self.node.childrenState.activeChildIndex) {
            [self.data setSelectedIndex:self.node.childrenState.activeChildIndex];
        }
        
        if (oldSelectedViewController != self.data.selectedViewController && context.animated && self.currentTransitionData) {
            [self.data.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                completion();
            }];
        } else {
            completion();
        }
    }];
}

- (void)stateDidChange:(LHNodeState)state {
}

#pragma mark - UITabBarBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [self.tools.channel startNodeUpdateWithBlock:^(id<LHNode> node) {
        NSUInteger activeChildIndex = [tabBarController.viewControllers indexOfObject:viewController];
        id<LHNode> activeChild = self.node.orderedChildren[activeChildIndex];
        
        LHLog(LHLogLevelInfo, @"Updating children state due to tab bar selection change");
        [node updateChildrenState:[LHTarget withActiveNode:activeChild]];
    }];
    
    [self updateForSelectedViewController:viewController];
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // TODO: support animated transitions
    [self.tools.channel finishNodeUpdate];
}

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    self.currentTransitionData =
        [LHViewControllerDriverHelpers containerTransitionDataForSourceViewController:fromVC
                                                            destinationViewController:toVC
                                                                             registry:self.transitionStyleRegistry
                                                                       driverProvider:self.tools.driverProvider
                                                                              options:@{}];
    
    return [self.currentTransitionData animationController];
}

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return [self.currentTransitionData interactionController];
}

#pragma mark - Helpers

- (NSArray<UIViewController *> *)childViewControllersForUpdateContext:(LHDriverUpdateContext *)context {
    NSSet<UIViewController *> *oldChildViewControllers = [NSSet setWithArray:self.data.viewControllers ?: @[]];
    
    NSArray<UIViewController *> *childViewControllers =
        [LHViewControllerDriverHelpers viewControllersForNodes:self.node.orderedChildren driverProvider:self.tools.driverProvider];
    
    for (UIViewController *viewController in childViewControllers) {
        if ([oldChildViewControllers containsObject:viewController]) {
            continue;
        }
        
        // This viewController is new, let's see if we have a tabBarItem for it.
        
        id<LHNode> childNode = viewController.lh_node;
        
        UITabBarItem *tabBarItem = [self tabBarItemForNode:childNode];
        if (tabBarItem) {
            viewController.tabBarItem = tabBarItem;
        }
    }
    
    return childViewControllers;
}

- (UITabBarItem *)tabBarItemForNode:(id<LHNode>)node {
    NSSet<id<LHNode>> *nodeDescendants = [LHNodeTree treeWithDescendantsOfNode:node].allItems;
    
    NSMutableSet *candidateNodes = [self.tabBarItemBoundNodes mutableCopy];
    [candidateNodes intersectSet:nodeDescendants];
    
    if (candidateNodes.count > 1) {
        LHAssertionFailure(@"Looking for a tabBarItem for node %@, found more than one", node);
        return nil;
    }
    
    return candidateNodes.count == 1 ? [self.tabBarItems objectForKey:candidateNodes.anyObject] : nil;
}

- (void)updateForSelectedViewController:(UIViewController *)childViewController {
    self.data.lh_childViewControllerForNavigationItem = childViewController;
}

@end
