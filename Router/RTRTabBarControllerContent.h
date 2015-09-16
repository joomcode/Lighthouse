//
//  RTRTabBarControllerContent.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContent.h"
#import <UIKit/UIKit.h>

@interface RTRTabBarControllerContent : NSObject <RTRNodeContent>

@property (nonatomic, readonly) UITabBarController *data;

@end
