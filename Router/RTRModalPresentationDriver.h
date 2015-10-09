//
//  RTRModalPresentationDriver.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriver.h"
#import <UIKit/UIKit.h>

@interface RTRModalPresentationDriver : NSObject <RTRDriver>

@property (nonatomic, readonly) UIWindow *data;

- (instancetype)initWithWindow:(UIWindow *)window;

@end
