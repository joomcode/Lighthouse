//
//  PXStateViewControllerDriver.h
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 03/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Lighthouse.h>

@interface PXStateViewControllerDriver : LHUpdateOrientedDriver

- (instancetype)initWithViewControllerClass:(Class)viewControllerClass;

@end
