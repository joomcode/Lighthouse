//
//  RTRViewControllerDriver.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriver.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface RTRViewControllerDriver : NSObject <RTRDriver>

@property (nonatomic, strong, readonly, nullable) UIViewController *data;

- (instancetype)initWithViewControllerClass:(Class)viewControllerClass NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END