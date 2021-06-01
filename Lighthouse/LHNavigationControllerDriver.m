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
#import "LHNavigationControllerTransitionOptions.h"
#import "LHTaskQueue.h"
#import "LHTarget.h"
#import "LHRouteHint.h"
#import "LHViewControllerDriverHelpers.h"
#import "LHContainerTransitionStyleRegistry.h"
#import "LHContainerTransitionData.h"

#define LH_TRACE_NAVIGATION_CONTROLLER_NOTIFICATIONS 0

@interface LHNavigationControllerDriver ()

@property (nonatomic, strong, readonly) LHStackNode *node;
@property (nonatomic, strong, readonly) LHDriverTools *tools;

@property (nonatomic, strong) LHContainerTransitionData *currentTransitionData;

@property (nonatomic, strong, nullable) id willShowObserver;
@property (nonatomic, strong, nullable) id didShowObserver;

@end


@implementation LHNavigationControllerDriver

#pragma mark - Init

- (instancetype)initWithNode:(LHStackNode *)node tools:(LHDriverTools *)tools {
    self = [super init];
    if (!self) return nil;
    
    _node = node;
    _tools = tools;
    
    [self subscribeToNotifications];
    
    return self;
}

#pragma mark - Dealloc

- (void)dealloc {
    [self unsubscribeFromNotifications];
    
    _data.delegate = nil;
}

#pragma mark - Public

- (LHContainerTransitionStyleRegistry *)transitionStyleRegistry {
    if (!_transitionStyleRegistry) {
        _transitionStyleRegistry = [[LHContainerTransitionStyleRegistry alloc] init];
    }
    return _transitionStyleRegistry;
}

#pragma mark - Subclassing

- (UINavigationController *)loadData {
    return [[UINavigationController alloc] init];
}

#pragma mark - LHDriver

@synthesize data = _data;

- (UINavigationController *)data {
    if (!_data) {
        _data = [self loadData];
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
        UIViewController *oldTopViewController = self.data.topViewController;
        UIViewController *newTopViewController = childViewControllers.lastObject;

        UINavigationControllerOperation operation = oldTopViewController == newTopViewController
            ? UINavigationControllerOperationNone
            : [self.data.viewControllers containsObject:newTopViewController]
                ? UINavigationControllerOperationPop
                : UINavigationControllerOperationPush;
        
        [self updateCurrentTransitionDataForSourceViewController:oldTopViewController
                                       destinationViewController:newTopViewController
                                                       operation:operation];
        
        [self.data setViewControllers:childViewControllers animated:context.animated];
        
        if (context.animated) {
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

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Handle pop prompted by the default Back button or gesture
    
    LHLogInfo(@"Will show view controller: %@", NSStringFromClass([viewController class]));
    
    NSUInteger count = [navigationController.viewControllers count];
    if (count >= [self.node.childrenState.stack count]) {
        return;
    }
    
    id<LHNode> oldActiveNode = self.node.childrenState.stack.lastObject;
    
    [self.tools.channel startNodeUpdateWithBlock:^(id<LHNode> node) {
        [node updateChildrenState:[LHTarget withInactiveNode:oldActiveNode]];
    }];
    
    [navigationController.transitionCoordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled]) {
            [self.tools.channel startUrgentNodeUpdateWithBlock:^(id<LHNode> node) {
                id<LHNode> activeNode = self.node.childrenState.stack.lastObject;
                
                LHRouteHint *hint = [[LHRouteHint alloc] initWithNodes:[NSOrderedSet orderedSetWithObject:activeNode]
                                                                origin:LHRouteHintOriginActiveNode
                                                         bidirectional:NO];
                
                [node updateChildrenState:[LHTarget withActiveNode:oldActiveNode routeHint:hint]];
            }];
        }
    }];
    
    [navigationController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.tools.channel finishNodeUpdate];
    }];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    LHLogInfo(@"Did show view controller: %@", NSStringFromClass([viewController class]));
    
    [self updateCurrentTransitionDataForPop];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    return [self.currentTransitionData animationController];
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return [self.currentTransitionData interactionController];
}

#pragma mark - NSObject

- (BOOL)respondsToSelector:(SEL)aSelector {
    // We have to pretend we don't implement delegate methods for transitions if we want to use the default ones.
    
    if (aSelector == @selector(navigationController:animationControllerForOperation:fromViewController:toViewController:) ||
        aSelector == @selector(navigationController:interactionControllerForAnimationController:)) {
        return self.currentTransitionData != nil;
    } else {
        return [super respondsToSelector:aSelector];
    }
}

#pragma mark - Private

- (void)setCurrentTransitionData:(LHContainerTransitionData *)currentTransitionData {
    if (_currentTransitionData == currentTransitionData) {
        return;
    }
    
    _currentTransitionData = currentTransitionData;
    
    // Force requery of delegate selectors' availability
    self.data.delegate = nil;
    self.data.delegate = self;
}

- (void)updateCurrentTransitionDataForPop {
    if (self.data.viewControllers.count < 2) {
        return;
    }
    
    UIViewController *sourceViewController = self.data.viewControllers.lastObject;
    UIViewController *destinationViewController = self.data.viewControllers[self.data.viewControllers.count - 2];
    
    [self updateCurrentTransitionDataForSourceViewController:sourceViewController
                                   destinationViewController:destinationViewController
                                                   operation:UINavigationControllerOperationPop];
}

- (void)updateCurrentTransitionDataForSourceViewController:(UIViewController *)sourceViewController
                                 destinationViewController:(UIViewController *)destinationViewController
                                                 operation:(UINavigationControllerOperation)operation {
    self.currentTransitionData =
        [LHViewControllerDriverHelpers containerTransitionDataForSourceViewController:sourceViewController
                                                            destinationViewController:destinationViewController
                                                                             registry:self.transitionStyleRegistry
                                                                       driverProvider:self.tools.driverProvider
                                                                              options:@{LHNavigationControllerOperationTransitionOption: @(operation)}];
}

#pragma mark - Notifications

- (void)subscribeToNotifications {
#if LH_TRACE_NAVIGATION_CONTROLLER_NOTIFICATIONS
    NSString *(^noteName)(NSString *) = ^(NSString *base) {
        return [NSString stringWithFormat:@"%@%@%@", @"UINavigationController", base, @"ShowViewControllerNotification"];
    };
    
    self.willShowObserver = [[NSNotificationCenter defaultCenter] addObserverForName:noteName(@"Will") object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        LHLogInfo(@"Received notification: %@", note);
    }];
    
    self.didShowObserver = [[NSNotificationCenter defaultCenter] addObserverForName:noteName(@"Did") object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        LHLogInfo(@"Received notification: %@", note);
    }];
#endif
}

- (void)unsubscribeFromNotifications {
#if LH_TRACE_NAVIGATION_CONTROLLER_NOTIFICATIONS
    [[NSNotificationCenter defaultCenter] removeObserver:self.willShowObserver];
    self.willShowObserver = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.didShowObserver];
    self.didShowObserver = nil;
#endif
}

@end
