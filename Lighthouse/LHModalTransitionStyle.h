//
//  LHModalTransitionStyle.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 06/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LHTransitionContext;

NS_ASSUME_NONNULL_BEGIN


@protocol LHModalTransitionStyle <NSObject>

// TODO: make optional?

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForContext:(LHTransitionContext *)context;

- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForContext:(LHTransitionContext *)context;

- (nullable UIPresentationController *)presentationControllerForContext:(LHTransitionContext *)context;

- (void)setupControllersForContext:(LHTransitionContext *)context;

@end


NS_ASSUME_NONNULL_END