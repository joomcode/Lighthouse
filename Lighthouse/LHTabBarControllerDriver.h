//
//  LHTabBarControllerDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriver.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface LHTabBarControllerDriver : NSObject <LHDriver>

@property (nonatomic, strong, readonly, nullable) UITabBarController *data;

@end


NS_ASSUME_NONNULL_END