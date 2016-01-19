//
//  RTRTabBarControllerDriver.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriver.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface RTRTabBarControllerDriver : NSObject <RTRDriver>

@property (nonatomic, strong, readonly, nullable) UITabBarController *data;

@end


NS_ASSUME_NONNULL_END