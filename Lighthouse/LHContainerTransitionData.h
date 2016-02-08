//
//  LHContainerTransitionData.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 07/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LHContainerTransitionStyle;
@class LHTransitionContext;

NS_ASSUME_NONNULL_BEGIN


@interface LHContainerTransitionData : NSObject

- (instancetype)initWithStyle:(id<LHContainerTransitionStyle>)style context:(LHTransitionContext *)context NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (id<UIViewControllerAnimatedTransitioning>)animationController;

- (id<UIViewControllerInteractiveTransitioning>)interactionController;

@end


NS_ASSUME_NONNULL_END