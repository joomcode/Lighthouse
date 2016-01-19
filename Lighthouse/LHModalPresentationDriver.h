//
//  LHModalPresentationDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriver.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface LHModalPresentationDriver : NSObject <LHDriver>

@property (nonatomic, strong, readonly) UIWindow *data;

- (instancetype)initWithWindow:(UIWindow *)window NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END