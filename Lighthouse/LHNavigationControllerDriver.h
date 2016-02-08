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
@class LHDriverTools;
@class LHContainerTransitionStyleRegistry;

NS_ASSUME_NONNULL_BEGIN


@interface LHNavigationControllerDriver : NSObject <LHDriver>

@property (nonatomic, strong, readonly) UINavigationController *data;

@property (nonatomic, strong, null_resettable) LHContainerTransitionStyleRegistry *transitionStyleRegistry;

- (instancetype)initWithNode:(LHStackNode *)node tools:(LHDriverTools *)tools;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END