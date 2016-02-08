//
//  LHViewControllerDriverHelpers.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LHNode;
@protocol LHDriverProvider;
@class LHModalTransitioningDelegate;
@class LHContainerTransitioning;
@class LHTransitionStyleRegistry;
@class LHTransitionStyleEntry;
@class LHTransitionContext;

NS_ASSUME_NONNULL_BEGIN


@interface LHViewControllerDriverHelpers : NSObject

+ (NSArray<UIViewController *> *)viewControllersForNodes:(id<NSFastEnumeration>)nodes
                                          driverProvider:(id<LHDriverProvider>)driverProvider;

+ (nullable LHModalTransitioningDelegate *)modalTransitioningDelegateForSourceViewController:(UIViewController *)sourceViewController
                                                                   destinationViewController:(UIViewController *)destinationViewController
                                                                                    registry:(LHTransitionStyleRegistry *)registry
                                                                              driverProvider:(id<LHDriverProvider>)driverProvider;

+ (nullable LHContainerTransitioning *)containerTransitioningForSourceViewController:(UIViewController *)sourceViewController
                                                           destinationViewController:(UIViewController *)destinationViewController
                                                                            registry:(LHTransitionStyleRegistry *)registry
                                                                      driverProvider:(id<LHDriverProvider>)driverProvider;

@end


@interface UIViewController (LHNode)

@property (nonatomic, weak, nullable) id<LHNode> lh_node;

@end


NS_ASSUME_NONNULL_END