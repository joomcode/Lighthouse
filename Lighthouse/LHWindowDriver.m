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
#import "UIViewController+LHDismissalTracking.h"

@interface LHWindowDriver ()

@property (nonatomic, strong, readonly) LHStackNode *node;
@property (nonatomic, strong, readonly) id<LHDriverChannel> channel;

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
    
    return self;
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
