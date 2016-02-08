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
@protocol LHDriverUpdateContext;
@class LHTransitionStyleRegistry;
@class LHTransitionContext;

NS_ASSUME_NONNULL_BEGIN


@interface LHViewControllerDriverHelpers : NSObject

+ (NSArray<UIViewController *> *)viewControllersForNodes:(id<NSFastEnumeration>)nodes
                                       withUpdateContext:(id<LHDriverUpdateContext>)updateContext;

+ (nullable id)transitionStyleForSourceViewController:(UIViewController *)sourceViewController
                            destinationViewController:(UIViewController *)destinationViewController
                                         withRegistry:(LHTransitionStyleRegistry *)registry;

+ (nullable LHTransitionContext *)transitionContextForSourceViewController:(UIViewController *)sourceViewController
                                                 destinationViewController:(UIViewController *)destinationViewController
                                                           transitionStyle:(id)transitionStyle
                                                                  registry:(LHTransitionStyleRegistry *)registry;

@end


@interface UIViewController (LHNode)

@property (nonatomic, weak, nullable) id<LHNode> lh_node;

@end


NS_ASSUME_NONNULL_END