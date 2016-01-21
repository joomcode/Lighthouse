//
//  LHNavigationControllerDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHContainerDriver.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface LHNavigationControllerDriver : LHContainerDriver

@property (nonatomic, strong, readonly, nullable) UINavigationController *data;

@end


NS_ASSUME_NONNULL_END