//
//  LHModalTransitioningDelegate.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 07/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHModalTransitioningDelegate.h"
#import "LHModalTransitionStyle.h"
#import "LHTransitionContext.h"

@interface LHModalTransitioningDelegate ()

@property (nonatomic, strong, readonly) id<LHModalTransitionStyle> style;
@property (nonatomic, strong, readonly) LHTransitionContext *context;

@end


@implementation LHModalTransitioningDelegate

#pragma mark - Init

- (instancetype)initWithStyle:(id<LHModalTransitionStyle>)style
                      context:(LHTransitionContext *)context {
    self = [super init];
    if (!self) return nil;
    
    _style = style;
    _context = context;
    
    return self;
}

#pragma mark - Public

- (void)prepareTransition {
    [self.style setupControllersForContext:self.context];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [self.style animationControllerForContext:self.context];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [self.style animationControllerForContext:self.context];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return [self.style interactionControllerForContext:self.context];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return [self.style interactionControllerForContext:self.context];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [self.style presentationControllerForContext:self.context];
}

@end
