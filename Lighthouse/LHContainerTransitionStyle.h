//
//  LHContainerTransitionStyle.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 06/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LHContainerTransitionContext;

NS_ASSUME_NONNULL_BEGIN


@protocol LHContainerTransitionStyle <NSObject>

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForContext:(LHContainerTransitionContext *)context;

- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForContext:(LHContainerTransitionContext *)context;

@end

   
NS_ASSUME_NONNULL_END