//
//  LHModalTransitionData.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 07/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LHModalTransitionStyle;
@class LHTransitionContext;

NS_ASSUME_NONNULL_BEGIN


@interface LHModalTransitionData : NSObject <UIViewControllerTransitioningDelegate>

- (instancetype)initWithStyle:(id<LHModalTransitionStyle>)style context:(LHTransitionContext *)context NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)prepareTransition;

@end


NS_ASSUME_NONNULL_END