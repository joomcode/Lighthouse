//
//  PXFlipModalTransitionStyle.m
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 07/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "PXFlipModalTransitionStyle.h"

@implementation PXFlipModalTransitionStyle

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForContext:(LHModalTransitionContext *)context {
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForContext:(LHModalTransitionContext *)context {
    return nil;
}

- (UIPresentationController *)presentationControllerForContext:(LHModalTransitionContext *)context {
    return nil;
}

- (void)setupControllersForContext:(LHModalTransitionContext *)context {
    context.viewControllerBeingPresented.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
}

@end
