//
//  AppDelegate.m
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "AppDelegate.h"
#import "PXStateViewControllerDriver.h"
#import "PXColorViewControllers.h"
#import "PXModalViewController.h"
#import "PXDeepModalViewController.h"
#import "PXNodeHierarchy.h"
#import "PXCommands.h"
#import "PXFlipModalTransitionStyle.h"
#import "PXFadeContainerTransitionStyle.h"
#import <Lighthouse/Lighthouse.h>

@interface AppDelegate () <LHRouterObserver>

@property (nonatomic, strong) LHRouter *router;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    [self setupRouter];
    
    [self performStuff];
    
    return YES;
}

- (void)setupRouter {
    // Nodes
    PXNodeHierarchy *hierarchy = [[PXNodeHierarchy alloc] init];
    
    
    // Drivers
    
    LHBlockDriverFactory *driverFactory = [[LHBlockDriverFactory alloc] init];
    
    [driverFactory bindNode:hierarchy.rootNode toBlock:^id<LHDriver>(LHStackNode *node, LHDriverTools *tools) {
        LHWindowDriver *driver = [[LHWindowDriver alloc] initWithWindow:self.window node:node tools:tools];
        
        [driver.transitionStyleRegistry registerTransitionStyle:[[PXFlipModalTransitionStyle alloc] init]
                                                  forSourceNode:nil
                                                destinationNode:hierarchy.modalNode];
        
        return driver;
    }];
    
    [driverFactory bindNodeClass:[LHStackNode class] toBlock:^id<LHDriver>(LHStackNode *node, LHDriverTools *tools) {
        LHNavigationControllerDriver *driver = [[LHNavigationControllerDriver alloc] initWithNode:node tools:tools];
        
        [driver.transitionStyleRegistry registerTransitionStyle:[[PXFadeContainerTransitionStyle alloc] init]
                                                  forSourceNode:nil
                                                destinationNode:hierarchy.redNode];
        
        return driver;
    }];
    
    [driverFactory bindNode:hierarchy.anotherTabNode toBlock:^id<LHDriver>(LHTabNode *node, LHDriverTools *tools) {
        LHTabBarControllerDriver *driver = [[LHTabBarControllerDriver alloc] initWithNode:node tools:tools];
        
        [driver bindDescendantNode:hierarchy.anotherRedNode toTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Foo" image:nil selectedImage:nil]];
        [driver bindDescendantNode:hierarchy.anotherGreenNode toTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Bar" image:nil selectedImage:nil]];
        [driver bindDescendantNode:hierarchy.anotherBlueNode toTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Derp" image:nil selectedImage:nil]];
        
        [driver.transitionStyleRegistry registerTransitionStyle:[[PXFadeContainerTransitionStyle alloc] init]
                                                  forSourceNode:nil
                                                destinationNode:hierarchy.anotherRedNode];
        
        return driver;
    }];
    
    [driverFactory bindNodes:@[ hierarchy.redNode, hierarchy.anotherRedNode ] toBlock:^id<LHDriver>(LHTabNode *node, LHDriverTools *tools) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXRedViewController class]];
    }];
    
    [driverFactory bindNodes:@[ hierarchy.greenNode, hierarchy.anotherGreenNode ] toBlock:^id<LHDriver>(LHTabNode *node, LHDriverTools *tools) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXGreenViewController class]];
    }];
    
    [driverFactory bindNodes:@[ hierarchy.blueNode, hierarchy.anotherBlueNode ] toBlock:^id<LHDriver>(LHTabNode *node, LHDriverTools *tools) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXBlueViewController class]];
    }];
    
    [driverFactory bindNodes:@[ hierarchy.modalNode ] toBlock:^id<LHDriver>(LHTabNode *node, LHDriverTools *tools) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXModalViewController class]];
    }];
    
    [driverFactory bindNode:hierarchy.deepModalNode toBlock:^id<LHDriver>(LHTabNode *node, LHDriverTools *tools) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXDeepModalViewController class]];
    }];
    
    
    // Command Registry
    
    LHBasicCommandRegistry *commandRegistry = [[LHBasicCommandRegistry alloc] init];
    
    [commandRegistry bindCommandClass:[PXPresentRed class] toTargetWithActiveNode:hierarchy.redNode];
    [commandRegistry bindCommandClass:[PXPresentGreen class] toTargetWithActiveNode:hierarchy.greenNode];
    [commandRegistry bindCommandClass:[PXPresentBlue class] toTargetWithActiveNode:hierarchy.blueNode];
    [commandRegistry bindCommandClass:[PXPresentModal class] toTargetWithActiveNode:hierarchy.deepModalNode];
    [commandRegistry bindCommandClass:[PXDismissModal class] toTarget:[LHTarget withInactiveNodes:@[ hierarchy.modalNode, hierarchy.deepModalNode ]]];
    [commandRegistry bindCommandClass:[PXPresentAnotherModal class] toTargetWithActiveNode:hierarchy.anotherBlueNode];

    
    // Router
    
    LHRouter *router = [[LHRouter alloc] initWithRootNode:hierarchy.rootNode
                                            driverFactory:driverFactory
                                          commandRegistry:commandRegistry];
    [router addObserver:self];
    
    self.router = router;
}

#pragma mark - Stuff

- (void)performStuff {
    [self doSomething];
    [self performSelector:@selector(doSomethingLater) withObject:nil afterDelay:3.0];
    [self performSelector:@selector(doSomethingEvenLater) withObject:nil afterDelay:6.0];
    [self performSelector:@selector(doSomethingEvenMoreLater) withObject:nil afterDelay:9.0];
}

- (void)doSomething {
    [self.router executeCommand:[[PXPresentGreen alloc] init]];
}

- (void)doSomethingLater {
    [self.router executeCommand:[[PXPresentAnotherModal alloc] init] completion:^{
        NSLog(@"hi there!");
    }];
    
//    [self.router executeCommand:[[PXPresentModal alloc] init] animated:YES];
//    [self.router executeCommand:[[PXPresentBlue alloc] init] animated:YES];
//    [self.router executeCommand:[[PXPresentAlert alloc] init] animated:YES];
//    [self.router executeCommand:[[PXDismissAlert alloc] init] animated:YES];
}

- (void)doSomethingEvenLater {
    [self.router executeCommand:[[PXPresentModal alloc] init]];
}

- (void)doSomethingEvenMoreLater {
    [self.router executeCommand:[[PXDismissModal alloc] init]];
}


//- (void)doSomething {
//    [self.router executeCommand:[[PXPresentRed alloc] init] animated:NO];
//}

//- (void)doSomethingLater {
//    [self.router executeCommand:[[PXPresentBlue alloc] init] animated:YES];
////    [self.router executeCommand:[[PXPresentGreen alloc] init] animated:YES];
////    [self.router executeCommand:[[PXPresentRed alloc] init] animated:YES];
////    [self.router executeCommand:[[PXPresentGreen alloc] init] animated:YES];
//}

#pragma mark - PXRouterObserver

- (void)routerStateDidChange:(LHRouter *)router {
}

@end
