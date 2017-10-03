//
//  LHTabBarControllerDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriver.h"
#import <UIKit/UIKit.h>

@protocol LHNode;
@class LHTabNode;
@class LHDriverTools;
@class LHContainerTransitionStyleRegistry;

NS_ASSUME_NONNULL_BEGIN


@interface LHTabBarControllerDriver : NSObject <LHDriver, UITabBarControllerDelegate>

@property (nonatomic, strong, readonly) UITabBarController *data;

@property (nonatomic, strong, null_resettable) LHContainerTransitionStyleRegistry *transitionStyleRegistry;

- (instancetype)initWithNode:(LHTabNode *)node tools:(LHDriverTools *)tools;

- (instancetype)init NS_UNAVAILABLE;

- (void)bindDescendantNode:(id<LHNode>)descendantNode toTabBarItem:(UITabBarItem *)tabBarItem;

@end


@interface LHTabBarControllerDriver (Subclassing)

- (UITabBarController *)loadData;

@end


NS_ASSUME_NONNULL_END
