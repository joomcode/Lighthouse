//
//  RTRViewControllerDriverHelpers.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRViewControllerDriverHelpers.h"
#import "RTRDriverUpdateContext.h"
#import "RTRNodeChildrenState.h"
#import "RTRDriver.h"
#import <UIKit/UIKit.h>

@implementation RTRViewControllerDriverHelpers

+ (NSArray *)childViewControllersWithUpdateContext:(id<RTRDriverUpdateContext>)updateContext {
    id<RTRNodeChildrenState> childrenState = updateContext.childrenState;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:childrenState.initializedChildren.count];
    
    for (id<RTRNode> childNode in childrenState.initializedChildren) {
        id<RTRDriver> childDriver = [updateContext driverForNode:childNode];
        NSAssert([childDriver.data isKindOfClass:[UIViewController class]], nil); // TODO
        [viewControllers addObject:childDriver.data];
    }
    
    return viewControllers;
}

@end
