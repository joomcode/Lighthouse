//
//  LHContainerTransitionStyle.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 06/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LHTransitionContext;

NS_ASSUME_NONNULL_BEGIN


@protocol LHContainerTransitionStyle <NSObject>

// TODO: make optional?

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForContext:(LHTransitionContext *)context;

- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForContext:(LHTransitionContext *)context;

@end

   
NS_ASSUME_NONNULL_END