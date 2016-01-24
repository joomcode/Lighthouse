//
//  LHViewControllerDriverHelpers.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHViewControllerDriverHelpers.h"
#import "LHDriverUpdateContext.h"
#import "LHNodeChildrenState.h"
#import "LHDriver.h"
#import <UIKit/UIKit.h>

@implementation LHViewControllerDriverHelpers

+ (NSArray<UIViewController *> *)viewControllersForNodes:(id<NSFastEnumeration>)nodes
                                       withUpdateContext:(id<LHDriverUpdateContext>)updateContext {

    NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray array];
    
    for (id<LHNode> node in nodes) {
        id<LHDriver> driver = [updateContext driverForNode:node];
        NSAssert([driver.data isKindOfClass:[UIViewController class]], nil); // TODO
        [viewControllers addObject:driver.data];
    }
    
    return viewControllers;
}

@end
