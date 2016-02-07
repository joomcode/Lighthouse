//
//  LHNavigationControllerDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriver.h"
#import <UIKit/UIKit.h>

@class LHStackNode;
@protocol LHNode;
@protocol LHDriverChannel;
@class LHContainerTransitionStyleRegistry;

NS_ASSUME_NONNULL_BEGIN


@interface LHNavigationControllerDriver : NSObject <LHDriver>

@property (nonatomic, strong, readonly) UINavigationController *data;

@property (nonatomic, strong, null_resettable) LHContainerTransitionStyleRegistry *transitionStyleRegistry;

- (instancetype)initWithNode:(LHStackNode *)node channel:(id<LHDriverChannel>)channel;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END