//
//  LHNavigationControllerDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNavigationControllerDriver.h"
#import "LHStackNode.h"
#import "LHDriverChannel.h"
#import "LHDriverUpdateContext.h"
#import "LHTaskQueue.h"
#import "LHTarget.h"
#import "LHViewControllerDriverHelpers.h"
#import "LHContainerTransitionStyle.h"
#import "LHContainerTransitionContext.h"
#import "LHContainerTransitionStyleRegistry.h"

@interface LHNavigationControllerDriver () <UINavigationControllerDelegate>

@property (nonatomic, strong, readonly) LHStackNode *node;
@property (nonatomic, strong, readonly) id<LHDriverChannel> channel;

@end


@implementation LHNavigationControllerDriver

#pragma mark - Init

- (instancetype)initWithNode:(LHStackNode *)node channel:(id<LHDriverChannel>)channel {
    self = [super init];
    if (!self) return nil;
    
    _node = node;
    _channel = channel;
    
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

- (void)updateWithContext:(id<LHDriverUpdateContext>)context {
    NSArray<UIViewController *> *childViewControllers =
        [LHViewControllerDriverHelpers viewControllersForNodes:self.node.childrenState.stack withUpdateContext:context];
    
    if ([childViewControllers isEqual:self.data.viewControllers]) {
        return;
    }
    
    [context.updateQueue runAsyncTaskWithBlock:^(LHTaskCompletionBlock completion) {
        [self.data setViewControllers:childViewControllers animated:context.animated];
        
        if (context.animated) {
            UIViewController *topChildViewController = childViewControllers.lastObject;
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
    
    [self.channel startNodeUpdateWithBlock:^(id<LHNode> node) {
        [node updateChildrenState:[LHTarget withInactiveNode:oldActiveNode]];
    }];
    
    [navigationController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled]) {
            [self.channel startNodeUpdateWithBlock:^(id<LHNode> node) {
                [node updateChildrenState:[LHTarget withActiveNode:oldActiveNode]];
            }];
        }
    }];
    
    [navigationController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.channel finishNodeUpdate];
    }];
}

@end
