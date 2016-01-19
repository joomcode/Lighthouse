//
//  LHModalPresentationDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHModalPresentationDriver.h"
#import "LHDriverUpdateContext.h"
#import "LHTaskQueue.h"
#import "LHNode.h"
#import "LHNodeChildrenState.h"
#import "LHDriverFeedbackChannel.h"
#import "LHTarget.h"
#import "LHViewControllerDriverHelpers.h"
#import "UIViewController+LHDismissalTracking.h"

@interface LHModalPresentationDriver ()

@property (nonatomic, strong) NSArray<id<LHNode>> *childNodes;

@end


@implementation LHModalPresentationDriver

#pragma mark - Init

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (!self) return nil;
    
    _data = window;
    
    return self;
}

#pragma mark - LHDriver

@synthesize data = _data;
@synthesize feedbackChannel = _feedbackChannel;

- (void)updateWithContext:(id<LHDriverUpdateContext>)context {
    NSAssert(context.childrenState.activeChildren.count <= 1, @""); // TODO
    NSAssert(context.childrenState.initializedChildren.lastObject == context.childrenState.activeChildren.anyObject, @""); // TODO
    
    self.childNodes = [context.childrenState.initializedChildren.array copy];
    
    NSArray<UIViewController *> *viewControllers = [LHViewControllerDriverHelpers childViewControllersWithUpdateContext:context];
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
                
                if (self.data.hidden) {
                    [self.data makeKeyAndVisible];
                }
            }];
        } else {
            UIViewController *presentingViewController = viewControllers[i - 1];
            
            [context.updateQueue runAsyncTaskWithBlock:^(LHTaskCompletionBlock completion) {
                viewController.lh_onDismissalBlock = [self onDismissalBlockForViewControllerAtIndex:i];
                [presentingViewController presentViewController:viewController animated:context.animated completion:completion];
            }];
        }
    }
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

- (LHViewControllerDismissalTrackingBlock)onDismissalBlockForViewControllerAtIndex:(NSInteger)index {
    return ^(UIViewController *viewController, BOOL animated) {
        // TODO: support non-animated?
        
        NSArray<id<LHNode>> *oldChildNodes = self.childNodes;
        
        [self startNodeUpdateWithChildNodes:[self.childNodes subarrayWithRange:NSMakeRange(0, index)]];
        
        [viewController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if ([context isCancelled]) {
                [self startNodeUpdateWithChildNodes:oldChildNodes];
            }
        }];
        
        [viewController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if (![context isCancelled]) {
                viewController.lh_onDismissalBlock = nil;
            }
            
            [self.feedbackChannel finishNodeUpdate];
        }];
    };
}

- (void)startNodeUpdateWithChildNodes:(NSArray *)childNodes {
    self.childNodes = childNodes;
    
    [self.feedbackChannel startNodeUpdateWithBlock:^(id<LHNode> node) {
        [node updateChildrenState:[LHTarget withActiveNode:childNodes.lastObject]];
    }];
}

@end
