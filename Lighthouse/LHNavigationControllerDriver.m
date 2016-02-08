//
//  LHNavigationControllerDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNavigationControllerDriver.h"
#import "LHStackNode.h"
#import "LHDriverTools.h"
#import "LHDriverChannel.h"
#import "LHDriverUpdateContext.h"
#import "LHTaskQueue.h"
#import "LHTarget.h"
#import "LHViewControllerDriverHelpers.h"
#import "LHContainerTransitionStyleRegistry.h"
#import "LHContainerTransitioning.h"

@interface LHNavigationControllerDriver () <UINavigationControllerDelegate>

@property (nonatomic, strong, readonly) LHStackNode *node;
@property (nonatomic, strong, readonly) LHDriverTools *tools;

@property (nonatomic, strong) LHContainerTransitioning *currentTransitioning;

@end


@implementation LHNavigationControllerDriver

#pragma mark - Init

- (instancetype)initWithNode:(LHStackNode *)node tools:(LHDriverTools *)tools {
    self = [super init];
    if (!self) return nil;
    
    _node = node;
    _tools = tools;
    
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

#pragma mark - LHDriver

@synthesize data = _data;

- (UINavigationController *)data {
    if (!_data) {
        _data = [[UINavigationController alloc] init];
        _data.delegate = self;
    }
    return _data;
}

- (void)updateWithContext:(LHDriverUpdateContext *)context {
    NSArray<UIViewController *> *childViewControllers =
        [LHViewControllerDriverHelpers viewControllersForNodes:self.node.childrenState.stack driverProvider:self.tools.driverProvider];
    
    if ([childViewControllers isEqual:self.data.viewControllers]) {
        return;
    }
    
    [context.updateQueue runAsyncTaskWithBlock:^(LHTaskCompletionBlock completion) {
        UIViewController *topChildViewController = childViewControllers.lastObject;
        
        [self updateCurrentTransitioningForSourceViewController:self.data.topViewController
                                      destinationViewController:topChildViewController];
        
        [self.data setViewControllers:childViewControllers animated:context.animated];
        
        if (context.animated) {
            [topChildViewController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                completion();
            }];
        } else {
            completion();
        }
    }];
}

- (void)presentationStateDidChange:(LHNodePresentationState)presentationState {
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Handle pop prompted by the default Back button or gesture
    
    NSUInteger count = [navigationController.viewControllers count];
    if (count >= [self.node.childrenState.stack count]) {
        return;
    }
    
    id<LHNode> oldActiveNode = self.node.childrenState.stack.lastObject;
    
    [self.tools.channel startNodeUpdateWithBlock:^(id<LHNode> node) {
        [node updateChildrenState:[LHTarget withInactiveNode:oldActiveNode]];
    }];
    
    [navigationController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled]) {
            [self.tools.channel startNodeUpdateWithBlock:^(id<LHNode> node) {
                [node updateChildrenState:[LHTarget withActiveNode:oldActiveNode]];
            }];
        }
    }];
    
    [navigationController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.tools.channel finishNodeUpdate];
    }];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self updateCurrentTransitioningForPop];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return [self.currentTransitioning animationController];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return [self.currentTransitioning interactionController];
}

#pragma mark - NSObject

- (BOOL)respondsToSelector:(SEL)aSelector {
    // We have to pretend we don't implement delegate methods for transitions if we want to use the default ones.
    
    if (aSelector == @selector(navigationController:animationControllerForOperation:fromViewController:toViewController:) ||
        aSelector == @selector(navigationController:interactionControllerForAnimationController:)) {
        return self.currentTransitioning != nil;
    } else {
        return [super respondsToSelector:aSelector];
    }
}

#pragma mark - Private

- (void)setCurrentTransitioning:(LHContainerTransitioning *)currentTransitioning {
    if (_currentTransitioning == currentTransitioning) {
        return;
    }
    
    _currentTransitioning = currentTransitioning;
    
    // Force requery of delegate selectors' availability
    self.data.delegate = nil;
    self.data.delegate = self;
}

- (void)updateCurrentTransitioningForPop {
    if (self.data.viewControllers.count < 2) {
        return;
    }
    
    UIViewController *sourceViewController = self.data.viewControllers.lastObject;
    UIViewController *destinationViewController = self.data.viewControllers[self.data.viewControllers.count - 2];
    
    [self updateCurrentTransitioningForSourceViewController:sourceViewController
                                  destinationViewController:destinationViewController];
}

- (void)updateCurrentTransitioningForSourceViewController:(UIViewController *)sourceViewController
                                destinationViewController:(UIViewController *)destinationViewController {
    self.currentTransitioning =
        [LHViewControllerDriverHelpers containerTransitioningForSourceViewController:sourceViewController
                                                           destinationViewController:destinationViewController
                                                                            registry:self.transitionStyleRegistry
                                                                      driverProvider:self.tools.driverProvider];
}

@end
