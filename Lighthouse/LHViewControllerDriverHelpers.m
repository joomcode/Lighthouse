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
    
    NSMutableSet<id<LHDriver>> *usedDrivers = [NSMutableSet set];
    
    for (id<LHNode> node in nodes) {
        id<LHDriver> driver = nil;
        
        NSArray<id<LHDriver>> *drivers = [driverProvider driversForNode:node];
        for (id<LHDriver> cadidate in drivers) {
            if (![usedDrivers containsObject:cadidate]) {
                driver = cadidate;
                [usedDrivers addObject:driver];
                break;
            }
        }
        
        if ([driver.data isKindOfClass:[UIViewController class]]) {
            UIViewController *viewController = driver.data;
            
            viewController.lh_node = node;
            [viewControllers addObject:viewController];
            
        } else if ([driver.data isKindOfClass:[NSArray class]]) {
            NSArray<UIViewController *> *controllers = driver.data;
            
            for (UIViewController *viewController in controllers) {
                viewController.lh_node = node;
            }
            [viewControllers addObjectsFromArray:controllers];
            
        } else {
            LHAssertionFailure(@"Expected a non-nil data of either UIViewController or NSArray<UIViewController *> type, got %@", driver.data);
        }
    }
    
    return viewControllers;
}

+ (LHModalTransitionData *)modalTransitionDataForSourceViewController:(UIViewController *)sourceViewController
                                            destinationViewController:(UIViewController *)destinationViewController
                                                             registry:(LHTransitionStyleRegistry *)registry
                                                       driverProvider:(id<LHDriverProvider>)driverProvider
                                                              options:(NSDictionary<NSString *, id> *)options {
    
    LHTransitionStyleEntry *entry = [self transitionStyleEntryForSourceViewController:sourceViewController
                                                            destinationViewController:destinationViewController
                                                                             registry:registry];
    
    if (!entry.transitionStyle) {
        return nil;
    }
    
    LHTransitionContext *context = [self transitionContextForSourceViewController:sourceViewController
                                                        destinationViewController:destinationViewController
                                                                            entry:entry
                                                                   driverProvider:driverProvider
                                                                          options:options];
    
    return [[LHModalTransitionData alloc] initWithStyle:entry.transitionStyle context:context];
}

+ (LHContainerTransitionData *)containerTransitionDataForSourceViewController:(UIViewController *)sourceViewController
                                                    destinationViewController:(UIViewController *)destinationViewController
                                                                     registry:(LHTransitionStyleRegistry *)registry
                                                               driverProvider:(id<LHDriverProvider>)driverProvider
                                                                      options:(NSDictionary<NSString *, id> *)options {
    
    LHTransitionStyleEntry *entry = [self transitionStyleEntryForSourceViewController:sourceViewController
                                                            destinationViewController:destinationViewController
                                                                             registry:registry];
    
    if (!entry) {
        return nil;
    }
    
    LHTransitionContext *context = [self transitionContextForSourceViewController:sourceViewController
                                                        destinationViewController:destinationViewController
                                                                            entry:entry
                                                                   driverProvider:driverProvider
                                                                          options:options];
    
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
                                                   driverProvider:(id<LHDriverProvider>)driverProvider
                                                          options:(NSDictionary<NSString *, id> *)options {
    UIViewController *styleSourceViewController =
        entry.sourceNode ? [driverProvider driverForNode:entry.sourceNode].data : sourceViewController;
    
    UIViewController *styleDestinationViewController =
        entry.destinationNode ? [driverProvider driverForNode:entry.destinationNode].data : destinationViewController;
    
    return [[LHTransitionContext alloc] initWithSource:sourceViewController
                                           destination:destinationViewController
                                           styleSource:styleSourceViewController
                                      styleDestination:styleDestinationViewController
                                               options:options];
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

