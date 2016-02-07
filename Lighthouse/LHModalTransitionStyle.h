//
//  LHModalTransitionStyle.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 06/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LHModalTransitionContext;

NS_ASSUME_NONNULL_BEGIN


@protocol LHModalTransitionStyle <NSObject>

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForContext:(LHModalTransitionContext *)context;

- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForContext:(LHModalTransitionContext *)context;

- (nullable UIPresentationController *)presentationControllerForContext:(LHModalTransitionContext *)context;

- (void)setupControllersForContext:(LHModalTransitionContext *)context;

@end


NS_ASSUME_NONNULL_END