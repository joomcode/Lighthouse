//
//  RTRViewControllerDriver.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriver.h"
#import <UIKit/UIKit.h>

@interface RTRViewControllerDriver : NSObject <RTRDriver>

@property (nonatomic, readonly) UIViewController *data;

- (instancetype)initWithViewControllerClass:(Class)viewControllerClass;

@end