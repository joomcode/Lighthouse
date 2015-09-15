//
//  RTRViewControllerContent.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContent.h"
#import <UIKit/UIKit.h>

@interface RTRViewControllerContent : NSObject <RTRNodeContent>

@property (nonatomic, readonly) UIViewController *data;

// TODO: machinery for command-based initialization and command handling

- (instancetype)initWithViewControllerClass:(Class)viewControllerClass;

@end
