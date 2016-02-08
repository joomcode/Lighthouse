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
#import "LHNodeTree.h"
#import "LHTransitionStyleRegistry.h"
#import "LHTransitionContext.h"
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

+ (id)transitionStyleForSourceViewController:(UIViewController *)sourceViewController
                   destinationViewController:(UIViewController *)destinationViewController
                                withRegistry:(LHTransitionStyleRegistry *)registry {
    id<LHNode> sourceNode = sourceViewController.lh_node;
    id<LHNode> destinationNode = destinationViewController.lh_node;
    
    if (!sourceNode || !destinationNode) {
        return nil;
    }
    
    return [registry transitionStyleForSourceNodes:[LHNodeTree treeWithDescendantsOfNode:sourceNode].allItems
                                  destinationNodes:[LHNodeTree treeWithDescendantsOfNode:destinationNode].allItems];
}

+ (nullable LHTransitionContext *)transitionContextForSourceViewController:(UIViewController *)sourceViewController
                                                 destinationViewController:(UIViewController *)destinationViewController
                                                           transitionStyle:(id)transitionStyle
                                                                  registry:(LHTransitionStyleRegistry *)registry {
    id<LHNode> styleSourceNode = [registry sourceNodeForTransitionStyle:transitionStyle];
    id<LHNode> styleDestinationNode = [registry destinationNodeForTransitionStyle:transitionStyle];
    
    UIViewController *styleSourceViewController = sourceViewController; // TODO
    UIViewController *styleDestinationViewController = destinationViewController; // TODO
    
    return [[LHTransitionContext alloc] initWithSource:sourceViewController
                                           destination:destinationViewController
                                           styleSource:styleSourceViewController
                                      styleDestination:styleDestinationViewController];
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

