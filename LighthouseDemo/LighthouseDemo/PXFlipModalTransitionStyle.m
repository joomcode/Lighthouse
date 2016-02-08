//
//  PXFlipModalTransitionStyle.m
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 07/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "PXFlipModalTransitionStyle.h"

@implementation PXFlipModalTransitionStyle

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForContext:(LHTransitionContext *)context {
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForContext:(LHTransitionContext *)context {
    return nil;
}

- (UIPresentationController *)presentationControllerForContext:(LHTransitionContext *)context {
    return nil;
}

- (void)setupControllersForContext:(LHTransitionContext *)context {
    context.destination.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

@end
