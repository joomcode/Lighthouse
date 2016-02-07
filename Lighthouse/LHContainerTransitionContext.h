//
//  LHContainerTransitionContext.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 06/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface LHContainerTransitionContext : NSObject

@property (nonatomic, strong, readonly) UIViewController *sourceViewController;

@property (nonatomic, strong, readonly) UIViewController *destinationViewController;

- (instancetype)initWithSourceViewController:(UIViewController *)sourceViewController
                   destinationViewController:(UIViewController *)destinationViewController NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END