//
//  RTRNavigationControllerDriver.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriver.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface RTRNavigationControllerDriver : NSObject <RTRDriver>

@property (nonatomic, readonly, nullable) UINavigationController *data;

@end


NS_ASSUME_NONNULL_END