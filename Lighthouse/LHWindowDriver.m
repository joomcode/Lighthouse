//
//  LHWindowDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHWindowDriver.h"
#import "LHStackNode.h"
#import "LHDriverTools.h"
#import "LHDriverChannel.h"
#import "LHDriverUpdateContext.h"
#import "LHTaskQueue.h"
#import "LHTarget.h"
#import "LHViewControllerDriverHelpers.h"
#import "LHModalTransitionStyleRegistry.h"
#import "LHModalTransitionData.h"
#import "UIViewController+LHDismissalTracking.h"

@interface LHWindowDriver ()

@property (nonatomic, strong, readonly) LHStackNode *node;
@property (nonatomic, strong, readonly) LHDriverTools *tools;

@property (nonatomic, strong, readonly) NSMapTable<UIViewController *, LHModalTransitionData *> *transitionDataByController;

@end


@implementation LHWindowDriver

#pragma mark - Init

- (instancetype)initWithWindow:(UIWindow *)window
                          node:(LHStackNode *)node
                         tools:(LHDriverTools *)tools {
    self = [super init];
    if (!self) return nil;
    
    _data = window;
    _node = node;
    _tools = tools;
    
    _transitionDataByController = [NSMapTable strongToStrongObjectsMapTable];
    
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

- (void)updateWithContext:(LHDriverUpdateContext *)context {
    NSArray<UIViewController *> *viewControllers =
        [LHViewControllerDriverHelpers viewControllersForNodes:self.node.childrenState.stack driverProvider:self.tools.driverProvider];
    
    NSArray<UIViewController *> *presentedViewControllers = [self presentedViewControllers];
    
    NSInteger commonPrefixLength = [self commonPrefixLengthForArray:viewControllers andArray:presentedViewControllers];

    for (NSInteger i = presentedViewControllers.count - 1; i >= MAX(commonPrefixLength, 1); --i) {
        UIViewController *viewController = presentedViewControllers[i];
        UIViewController *presentingViewController = presentedViewControllers[i - 1];
        
        [context.updateQueue runAsyncTaskWithBlock:^(LHTaskCompletionBlock completion) {
            viewController.lh_onDismissalBlock = nil;
            
            if (![viewController isBeingDismissed]) {
                [presentingViewController dismissViewControllerAnimated:context.animated completion:completion];
            } else {
                [viewController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                    completion();
                }];
            }
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
                                   animated:context.animated
                                 completion:completion];
            }];
        }
    }
}

- (void)stateDidChange:(LHNodeState)state {
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
                     animated:(BOOL)animated
                   completion:(LHTaskCompletionBlock)completion {
    
    LHModalTransitionData *transitionData =
        [LHViewControllerDriverHelpers modalTransitionDataForSourceViewController:presentingViewController
                                                        destinationViewController:viewControllerToPresent
                                                                         registry:self.transitionStyleRegistry
                                                                   driverProvider:self.tools.driverProvider];
    
    if (transitionData) {
        // TODO: cleanup this later (on dismissal?)
        [self.transitionDataByController setObject:transitionData forKey:viewControllerToPresent];
        
        viewControllerToPresent.transitioningDelegate = transitionData;
        
        [transitionData prepareTransition];
    }
    
    [presentingViewController presentViewController:viewControllerToPresent animated:animated completion:completion];
}

- (LHViewControllerDismissalTrackingBlock)onDismissalBlockForViewControllerAtIndex:(NSInteger)index {
    return ^(UIViewController *viewController, BOOL animated) {
        // TODO: support non-animated?
        
        id<LHNode> oldActiveNode = self.node.childrenState.stack.lastObject;
        id<LHNode> newActiveNode = self.node.childrenState.stack[index - 1];
        
        [self.tools.channel startNodeUpdateWithBlock:^(id<LHNode> node) {
            [self.node updateChildrenState:[LHTarget withActiveNode:newActiveNode]];
        }];
        
        [viewController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if ([context isCancelled]) {
                [self.tools.channel startNodeUpdateWithBlock:^(id<LHNode> node) {
                    [self.node updateChildrenState:[LHTarget withActiveNode:oldActiveNode]];
                }];
            }
        }];
        
        [viewController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if (![context isCancelled]) {
                viewController.lh_onDismissalBlock = nil;
            }
            
            [self.tools.channel finishNodeUpdate];
        }];
    };
}

@end
