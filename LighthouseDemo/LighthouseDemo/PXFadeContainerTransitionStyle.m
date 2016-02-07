//
//  PXFadeContainerTransitionStyle.m
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 07/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "PXFadeContainerTransitionStyle.h"

@interface PXFadeContainerTransitionStyle () <UIViewControllerAnimatedTransitioning>

@end


@implementation PXFadeContainerTransitionStyle

#pragma mark - LHContainerTransitionStyle

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForContext:(LHContainerTransitionContext *)context {
    return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForContext:(LHContainerTransitionContext *)context {
    return nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
        toViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
