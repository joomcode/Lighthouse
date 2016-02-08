//
//  LHWindowDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHWindowDriver.h"
#import "LHStackNode.h"
#import "LHDriverChannel.h"
#import "LHDriverUpdateContext.h"
#import "LHTaskQueue.h"
#import "LHTarget.h"
#import "LHViewControllerDriverHelpers.h"
#import "LHNodeTree.h"
#import "LHTransitionContext.h"
#import "LHModalTransitionStyle.h"
#import "LHModalTransitionStyleRegistry.h"
#import "LHModalTransitioningDelegate.h"
#import "UIViewController+LHDismissalTracking.h"

@interface LHWindowDriver ()

@property (nonatomic, strong, readonly) LHStackNode *node;
@property (nonatomic, strong, readonly) id<LHDriverChannel> channel;

@property (nonatomic, strong, readonly) NSMapTable<UIViewController *, LHModalTransitioningDelegate *> *transitioningDelegates;

@end


@implementation LHWindowDriver

#pragma mark - Init

- (instancetype)initWithWindow:(UIWindow *)window
                          node:(LHStackNode *)node
                       channel:(id<LHDriverChannel>)channel {
    self = [super init];
    if (!self) return nil;
    
    _data = window;
    _node = node;
    _channel = channel;
    
    _transitioningDelegates = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - Public

- (LHModalTransitionStyleRegistry *)transitionStyleRegistry {
    if (!_transitionStyleRegistry) {
        _transitionStyleRegistry = [[LHModalTransitionStyleRegistry alloc] init];
    }
    return _transitionStyleRegistry;
}

#pragma mark - LHDriver

@synthesize data = _data;

- (void)updateWithContext:(id<LHDriverUpdateContext>)context {
    NSArray<UIViewController *> *viewControllers =
        [LHViewControllerDriverHelpers viewControllersForNodes:self.node.childrenState.stack withUpdateContext:context];
    
    NSArray<UIViewController *> *presentedViewControllers = [self presentedViewControllers];
    
    NSInteger commonPrefixLength = [self commonPrefixLengthForArray:viewControllers andArray:presentedViewControllers];

    for (NSInteger i = presentedViewControllers.count - 1; i >= MAX(commonPrefixLength, 1); --i) {
        UIViewController *viewController = presentedViewControllers[i];
        UIViewController *presentingViewController = presentedViewControllers[i - 1];
        
        [context.updateQueue runAsyncTaskWithBlock:^(LHTaskCompletionBlock completion) {
            viewController.lh_onDismissalBlock = nil;
            [presentingViewController dismissViewControllerAnimated:context.animated completion:completion];
        }];
    }
    
    for (NSInteger i = commonPrefixLength; i < viewControllers.count; ++i) {
        UIViewController *viewController = viewControllers[i];
        
        if (i == 0) {
            [context.updateQueue runTaskWithBlock:^{
                self.data.rootViewController = viewController;
            }];
        } else {
            UIViewController *presentingViewController = viewControllers[i - 1];
            
            [context.updateQueue runAsyncTaskWithBlock:^(LHTaskCompletionBlock completion) {
                viewController.lh_onDismissalBlock = [self onDismissalBlockForViewControllerAtIndex:i];
                
                [self presentViewController:viewController
                         fromViewController:presentingViewController
                                    context:context
                                 completion:completion];
            }];
        }
    }
}

- (void)presentationStateDidChange:(LHNodePresentationState)presentationState {
}

#pragma mark - Private

- (NSArray *)presentedViewControllers {
    NSMutableArray<UIViewController *> *viewControllers = [[NSMutableArray alloc] init];
    
    UIViewController *currentViewController = self.data.rootViewController;
    
    while (currentViewController) {
        [viewControllers addObject:currentViewController];
        currentViewController = currentViewController.presentedViewController;
    }
    
    return viewControllers;
}

- (NSInteger)commonPrefixLengthForArray:(NSArray *)array1 andArray:(NSArray *)array2 {
    NSInteger i = 0;
    while (i < array1.count && i < array2.count && [array1[i] isEqual:array2[i]]) {
        ++i;
    }
    return i;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent
           fromViewController:(UIViewController *)presentingViewController
                      context:(id<LHDriverUpdateContext>)context
                   completion:(LHTaskCompletionBlock)completion {
    id<LHModalTransitionStyle> transitionStyle =
        [LHViewControllerDriverHelpers transitionStyleForSourceViewController:presentingViewController
                                                    destinationViewController:viewControllerToPresent
                                                                 withRegistry:self.transitionStyleRegistry];
    
    if (transitionStyle) {
        LHTransitionContext *transitionContext =
            [LHViewControllerDriverHelpers transitionContextForSourceViewController:presentingViewController
                                                          destinationViewController:viewControllerToPresent
                                                                    transitionStyle:transitionStyle
                                                                           registry:self.transitionStyleRegistry];
        
        LHModalTransitioningDelegate *transitioningDelegate = [[LHModalTransitioningDelegate alloc] initWithStyle:transitionStyle
                                                                                                          context:transitionContext];
        
        // TODO: cleanup this later (on dismissal?)
        [self.transitioningDelegates setObject:transitioningDelegate forKey:viewControllerToPresent];
        
        viewControllerToPresent.transitioningDelegate = transitioningDelegate;
        [transitionStyle setupControllersForContext:transitionContext];
    }
    
    [presentingViewController presentViewController:viewControllerToPresent animated:context.animated completion:completion];
}

- (LHViewControllerDismissalTrackingBlock)onDismissalBlockForViewControllerAtIndex:(NSInteger)index {
    return ^(UIViewController *viewController, BOOL animated) {
        // TODO: support non-animated?
        
        id<LHNode> oldActiveNode = self.node.childrenState.stack.lastObject;
        id<LHNode> newActiveNode = self.node.childrenState.stack[index - 1];
        
        [self.channel startNodeUpdateWithBlock:^(id<LHNode> node) {
            [self.node updateChildrenState:[LHTarget withActiveNode:newActiveNode]];
        }];
        
        [viewController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if ([context isCancelled]) {
                [self.channel startNodeUpdateWithBlock:^(id<LHNode> node) {
                    [self.node updateChildrenState:[LHTarget withActiveNode:oldActiveNode]];
                }];
            }
        }];
        
        [viewController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if (![context isCancelled]) {
                viewController.lh_onDismissalBlock = nil;
            }
            
            [self.channel finishNodeUpdate];
        }];
    };
}

@end
