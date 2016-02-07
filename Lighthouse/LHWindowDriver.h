//
//  LHWindowDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriver.h"
#import <UIKit/UIKit.h>

@class LHStackNode;
@protocol LHDriverChannel;
@class LHModalTransitionStyleRegistry;

NS_ASSUME_NONNULL_BEGIN


@interface LHWindowDriver : NSObject <LHDriver>

@property (nonatomic, strong, readonly) UIWindow *data;

@property (nonatomic, strong, null_resettable) LHModalTransitionStyleRegistry *transitionStyleRegistry;

- (instancetype)initWithWindow:(UIWindow *)window
                          node:(LHStackNode *)node
                       channel:(id<LHDriverChannel>)channel NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END