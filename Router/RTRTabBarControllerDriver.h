//
//  RTRTabBarControllerDriver.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriver.h"
#import <UIKit/UIKit.h>

@interface RTRTabBarControllerDriver : NSObject <RTRDriver>

@property (nonatomic, readonly) UITabBarController *data;

@end
