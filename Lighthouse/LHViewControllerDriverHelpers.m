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

+ (NSArray<UIViewController *> *)childViewControllersWithUpdateContext:(id<LHDriverUpdateContext>)updateContext {
    id<LHNodeChildrenState> childrenState = updateContext.childrenState;
    
    NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray arrayWithCapacity:childrenState.initializedChildren.count];
    
    for (id<LHNode> childNode in childrenState.initializedChildren) {
        id<LHDriver> childDriver = [updateContext driverForNode:childNode];
        NSAssert([childDriver.data isKindOfClass:[UIViewController class]], nil); // TODO
        [viewControllers addObject:childDriver.data];
    }
    
    return viewControllers;
}

@end
