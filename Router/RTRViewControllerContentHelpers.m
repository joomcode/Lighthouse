//
//  RTRViewControllerContentHelpers.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRViewControllerContentHelpers.h"
#import "RTRNodeContentUpdateContext.h"
#import "RTRNodeChildrenState.h"
#import "RTRNodeContent.h"
#import <UIKit/UIKit.h>

@implementation RTRViewControllerContentHelpers

+ (NSArray *)childViewControllersWithUpdateContext:(id<RTRNodeContentUpdateContext>)updateContext {
    id<RTRNodeChildrenState> childrenState = updateContext.childrenState;
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:childrenState.initializedChildren.count];
    
    for (id<RTRNode> childNode in childrenState.initializedChildren) {
        id<RTRNodeContent> childContent = [updateContext contentForNode:childNode];
        NSAssert([childContent.data isKindOfClass:[UIViewController class]], nil); // TODO
        [viewControllers addObject:childContent.data];
    }
    
    return viewControllers;
}

@end
