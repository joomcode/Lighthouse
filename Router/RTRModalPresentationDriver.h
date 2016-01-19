//
//  RTRModalPresentationDriver.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriver.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface RTRModalPresentationDriver : NSObject <RTRDriver>

@property (nonatomic, readonly) UIWindow *data;

- (instancetype)initWithWindow:(UIWindow *)window NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END