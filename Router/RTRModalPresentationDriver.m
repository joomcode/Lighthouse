//
//  RTRModalPresentationDriver.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRModalPresentationDriver.h"
#import "RTRDriverUpdateContext.h"
#import "RTRTaskQueue.h"
#import "RTRNode.h"
#import "RTRNodeChildrenState.h"
#import "RTRDriverFeedbackChannel.h"
#import "RTRTarget.h"
#import "RTRViewControllerDriverHelpers.h"
#import "UIViewController+RTRDismissalTracking.h"

@interface RTRModalPresentationDriver ()

@property (nonatomic, strong) NSArray *childNodes;

@end


@implementation RTRModalPresentationDriver

#pragma mark - Init

- (instancetype)init {
    return [self initWithWindow:nil];
}

- (instancetype)initWithWindow:(UIWindow *)window {
    NSParameterAssert(window != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _data = window;
    
    return self;
}

#pragma mark - RTRDriver

@synthesize data = _data;
@synthesize feedbackChannel = _feedbackChannel;

- (void)updateWithContext:(id<RTRDriverUpdateContext>)context {
    NSAssert(context.childrenState.activeChildren.count <= 1, @""); // TODO
    NSAssert(context.childrenState.initializedChildren.lastObject == context.childrenState.activeChildren.anyObject, @""); // TODO
    
    self.childNodes = [context.childrenState.initializedChildren.array copy];
    
    NSArray *viewControllers = [RTRViewControllerDriverHelpers childViewControllersWithUpdateContext:context];
    NSArray *presentedViewControllers = [self presentedViewControllers];
    
    NSInteger commonPrefixLength = [self commonPrefixLengthForArray:viewControllers andArray:presentedViewControllers];

    for (NSInteger i = presentedViewControllers.count - 1; i >= MAX(commonPrefixLength, 1); --i) {
        UIViewController *viewController = presentedViewControllers[i];
        UIViewController *presentingViewController = presentedViewControllers[i - 1];
        
        [context.updateQueue runAsyncTaskWithBlock:^(RTRTaskCompletionBlock completion) {
            viewController.rtr_onDismissalBlock = nil;
            [presentingViewController dismissViewControllerAnimated:context.animated completion:completion];
        }];
    }
    
    for (NSInteger i = commonPrefixLength; i < viewControllers.count; ++i) {
        UIViewController *viewController = viewControllers[i];
        
        if (i == 0) {
            [context.updateQueue runTaskWithBlock:^{
                self.data.rootViewController = viewController;
                
                if (self.data.hidden) {
                    [self.data makeKeyAndVisible];
                }
            }];
        } else {
            UIViewController *presentingViewController = viewControllers[i - 1];
            
            [context.updateQueue runAsyncTaskWithBlock:^(RTRTaskCompletionBlock completion) {
                viewController.rtr_onDismissalBlock = [self onDismissalBlockForViewControllerAtIndex:i];
                [presentingViewController presentViewController:viewController animated:context.animated completion:completion];
            }];
        }
    }
}

#pragma mark - Private

- (NSArray *)presentedViewControllers {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
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

- (RTRViewControllerDismissalTrackingBlock)onDismissalBlockForViewControllerAtIndex:(NSInteger)index {
    return ^(UIViewController *viewController, BOOL animated) {
        // TODO: support non-animated?
        
        NSArray *oldChildNodes = self.childNodes;
        
        [self startNodeUpdateWithChildNodes:[self.childNodes subarrayWithRange:NSMakeRange(0, index)]];
        
        [viewController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if ([context isCancelled]) {
                [self startNodeUpdateWithChildNodes:oldChildNodes];
            }
        }];
        
        [viewController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if (![context isCancelled]) {
                viewController.rtr_onDismissalBlock = nil;
            }
            
            [self.feedbackChannel finishNodeUpdate];
        }];
    };
}

- (void)startNodeUpdateWithChildNodes:(NSArray *)childNodes {
    self.childNodes = childNodes;
    
    [self.feedbackChannel startNodeUpdateWithBlock:^(id<RTRNode> node) {
        [node updateChildrenState:[RTRTarget withActiveNode:childNodes.lastObject]];
    }];
}

@end
