//
//  LHModalTransitionContext.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 06/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface LHModalTransitionContext : NSObject

@property (nonatomic, strong, readonly) UIViewController *sourceViewController;

@property (nonatomic, strong, readonly) UIViewController *destinationViewController;

@property (nonatomic, strong, readonly) UIViewController *presentingViewController;

@property (nonatomic, strong, readonly) UIViewController *viewControllerBeingPresented;

- (instancetype)initWithSourceViewController:(UIViewController *)sourceViewController
                   destinationViewController:(UIViewController *)destinationViewController
                    presentingViewController:(UIViewController *)presentingViewController
                viewControllerBeingPresented:(UIViewController *)viewControllerBeingPresented NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;


@end


NS_ASSUME_NONNULL_END