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
#import <objc/runtime.h>

@implementation LHViewControllerDriverHelpers

+ (NSArray<UIViewController *> *)viewControllersForNodes:(id<NSFastEnumeration>)nodes
                                       withUpdateContext:(id<LHDriverUpdateContext>)updateContext {

    NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray array];
    
    for (id<LHNode> node in nodes) {
        id<LHDriver> driver = [updateContext driverForNode:node];
        NSAssert([driver.data isKindOfClass:[UIViewController class]], nil); // TODO
        
        UIViewController *viewController = driver.data;
        viewController.lh_node = node;
        [viewControllers addObject:viewController];
    }
    
    return viewControllers;
}

@end


@implementation UIViewController (LHNode)

static const char kNodeKey;

- (id<LHNode>)lh_node {
    return objc_getAssociatedObject(self, &kNodeKey);
}

- (void)setLh_node:(id<LHNode>)node {
    objc_setAssociatedObject(self, &kNodeKey, node, OBJC_ASSOCIATION_ASSIGN);
}

@end

