//
//  LHViewControllerDriverHelpers.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHViewControllerDriverHelpers.h"
#import "LHDriverProvider.h"
#import "LHNodeChildrenState.h"
#import "LHDriver.h"
#import "LHNodeTree.h"
#import "LHModalTransitionData.h"
#import "LHContainerTransitionData.h"
#import "LHTransitionStyleRegistry.h"
#import "LHTransitionContext.h"
#import <objc/runtime.h>

@implementation LHViewControllerDriverHelpers

#pragma mark - Public

+ (NSArray<UIViewController *> *)viewControllersForNodes:(id<NSFastEnumeration>)nodes
                                          driverProvider:(id<LHDriverProvider>)driverProvider {
    NSMutableArray<UIViewController *> *viewControllers = [NSMutableArray array];
    
    for (id<LHNode> node in nodes) {
        id<LHDriver> driver = [driverProvider driverForNode:node];
        NSAssert([driver.data isKindOfClass:[UIViewController class]], nil); // TODO
        
        UIViewController *viewController = driver.data;
        viewController.lh_node = node;
        [viewControllers addObject:viewController];
    }
    
    return viewControllers;
}

+ (LHModalTransitionData *)modalTransitionDataForSourceViewController:(UIViewController *)sourceViewController
                                            destinationViewController:(UIViewController *)destinationViewController
                                                             registry:(LHTransitionStyleRegistry *)registry
                                                       driverProvider:(id<LHDriverProvider>)driverProvider {
    
    LHTransitionStyleEntry *entry = [self transitionStyleEntryForSourceViewController:sourceViewController
                                                            destinationViewController:destinationViewController
                                                                             registry:registry];
    
    if (!entry) {
        return nil;
    }
    
    LHTransitionContext *context = [self transitionContextForSourceViewController:sourceViewController
                                                        destinationViewController:destinationViewController
                                                                            entry:entry
                                                                   driverProvider:driverProvider];
    
    return [[LHModalTransitionData alloc] initWithStyle:entry.transitionStyle context:context];
}

+ (LHContainerTransitionData *)containerTransitionDataForSourceViewController:(UIViewController *)sourceViewController
                                                    destinationViewController:(UIViewController *)destinationViewController
                                                                     registry:(LHTransitionStyleRegistry *)registry
                                                               driverProvider:(id<LHDriverProvider>)driverProvider {
    
    LHTransitionStyleEntry *entry = [self transitionStyleEntryForSourceViewController:sourceViewController
                                                            destinationViewController:destinationViewController
                                                                             registry:registry];
    
    if (!entry) {
        return nil;
    }
    
    LHTransitionContext *context = [self transitionContextForSourceViewController:sourceViewController
                                                        destinationViewController:destinationViewController
                                                                            entry:entry
                                                                   driverProvider:driverProvider];
    
    return [[LHContainerTransitionData alloc] initWithStyle:entry.transitionStyle context:context];
}

#pragma mark - Private

+ (LHTransitionStyleEntry *)transitionStyleEntryForSourceViewController:(UIViewController *)sourceViewController
                                              destinationViewController:(UIViewController *)destinationViewController
                                                               registry:(LHTransitionStyleRegistry *)registry {
    id<LHNode> sourceNode = sourceViewController.lh_node;
    id<LHNode> destinationNode = destinationViewController.lh_node;
    
    if (!sourceNode || !destinationNode) {
        return nil;
    }
    
    return [registry entryForSourceNodes:[LHNodeTree treeWithDescendantsOfNode:sourceNode].allItems
                        destinationNodes:[LHNodeTree treeWithDescendantsOfNode:destinationNode].allItems];
}

+ (LHTransitionContext *)transitionContextForSourceViewController:(UIViewController *)sourceViewController
                                        destinationViewController:(UIViewController *)destinationViewController
                                                            entry:(LHTransitionStyleEntry *)entry
                                                   driverProvider:(id<LHDriverProvider>)driverProvider {
    UIViewController *styleSourceViewController =
        entry.sourceNode ? [driverProvider driverForNode:entry.sourceNode].data : sourceViewController;
    
    UIViewController *styleDestinationViewController =
        entry.destinationNode ? [driverProvider driverForNode:entry.destinationNode].data : destinationViewController;
    
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

