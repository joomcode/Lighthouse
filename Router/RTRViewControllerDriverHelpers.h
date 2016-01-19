//
//  RTRViewControllerDriverHelpers.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol RTRDriverUpdateContext;

NS_ASSUME_NONNULL_BEGIN


@interface RTRViewControllerDriverHelpers : NSObject

+ (NSArray<UIViewController *> *)childViewControllersWithUpdateContext:(id<RTRDriverUpdateContext>)updateContext;

@end


NS_ASSUME_NONNULL_END