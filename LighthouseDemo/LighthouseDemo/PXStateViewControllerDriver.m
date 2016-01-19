//
//  PXStateViewControllerDriver.m
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 03/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "PXStateViewControllerDriver.h"
#import "PXStateViewController.h"

@implementation PXStateViewControllerDriver

- (instancetype)initWithViewControllerClass:(Class)viewControllerClass {
    self = [super init];
    if (!self) return nil;
    
    self.defaultDataInitBlock = ^(id<LHCommand> command, id<LHUpdateBus> updateBus) {
        return [[viewControllerClass alloc] init];
    };
    
    return self;
}

@end
