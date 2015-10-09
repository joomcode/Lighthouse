//
//  PXStateDisplayingViewControllerDriver.h
//  RouterDemo
//
//  Created by Nick Tymchenko on 03/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Router.h>

@interface PXStateDisplayingViewControllerDriver : RTRUpdateOrientedDriver

- (instancetype)initWithViewControllerClass:(Class)viewControllerClass;

@end
