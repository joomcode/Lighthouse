//
//  RTRNavigationControllerContent.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContent.h"
#import <UIKit/UIKit.h>

@interface RTRNavigationControllerContent : NSObject <RTRNodeContent>

@property (nonatomic, readonly) UINavigationController *data;

@end
