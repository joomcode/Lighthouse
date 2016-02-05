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
#import <Lighthouse.h>

@interface AppDelegate () <LHRouterDelegate>

@property (nonatomic, strong) LHRouter *router;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [self setupRouter];
    
    [self performStuff];
    
    return YES;
}

- (void)setupRouter {
    // Nodes
    PXNodeHierarchy *hierarchy = [[PXNodeHierarchy alloc] init];
    
    
    // Drivers
    
    LHBasicDriverProvider *driverProvider = [[LHBasicDriverProvider alloc] init];
    
    [driverProvider bindNode:hierarchy.rootNode toBlock:^id<LHDriver>(LHStackNode *node, id<LHDriverProviderContext> context) {
        return [[LHWindowDriver alloc] initWithWindow:self.window node:node channel:context.channel];
    }];
    
    [driverProvider bindNodeClass:[LHStackNode class] toBlock:^id<LHDriver>(LHStackNode *node, id<LHDriverProviderContext> context) {
        return [[LHNavigationControllerDriver alloc] initWithNode:node channel:context.channel];
    }];
    
    [driverProvider bindNode:hierarchy.anotherTabNode toBlock:^id<LHDriver>(LHTabNode *node, id<LHDriverProviderContext> context) {
        LHTabBarControllerDriver *driver = [[LHTabBarControllerDriver alloc] initWithNode:node channel:context.channel];
        
        [driver bindChildNode:hierarchy.anotherRedNode toTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Foo" image:nil selectedImage:nil]];
        [driver bindChildNode:hierarchy.anotherGreenNode toTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Bar" image:nil selectedImage:nil]];
        [driver bindChildNode:hierarchy.anotherBlueNode toTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Derp" image:nil selectedImage:nil]];
        
        return driver;
    }];
    
    [driverProvider bindNodes:@[ hierarchy.redNode, hierarchy.anotherRedNode ] toBlock:^id<LHDriver>(LHTabNode *node, id<LHDriverProviderContext> context) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXRedViewController class]];
    }];
    
    [driverProvider bindNodes:@[ hierarchy.greenNode, hierarchy.anotherGreenNode ] toBlock:^id<LHDriver>(LHTabNode *node, id<LHDriverProviderContext> context) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXGreenViewController class]];
    }];
    
    [driverProvider bindNodes:@[ hierarchy.blueNode, hierarchy.anotherBlueNode ] toBlock:^id<LHDriver>(LHTabNode *node, id<LHDriverProviderContext> context) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXBlueViewController class]];
    }];
    
    [driverProvider bindNodes:@[ hierarchy.modalNode ] toBlock:^id<LHDriver>(LHTabNode *node, id<LHDriverProviderContext> context) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXModalViewController class]];
    }];
    
    [driverProvider bindNode:hierarchy.deepModalNode toBlock:^id<LHDriver>(LHTabNode *node, id<LHDriverProviderContext> context) {
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
                                             driverProvider:driverProvider
                                            commandRegistry:commandRegistry];
    router.delegate = self;
    
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
    [self.router executeCommand:[[PXPresentGreen alloc] init] animated:NO];
}

- (void)doSomethingLater {
    [self.router executeCommand:[[PXPresentAnotherModal alloc] init] animated:YES];
    
//    [self.router executeCommand:[[PXPresentModal alloc] init] animated:YES];
//    [self.router executeCommand:[[PXPresentBlue alloc] init] animated:YES];
//    [self.router executeCommand:[[PXPresentAlert alloc] init] animated:YES];
//    [self.router executeCommand:[[PXDismissAlert alloc] init] animated:YES];
}

- (void)doSomethingEvenLater {
    [self.router executeCommand:[[PXPresentModal alloc] init] animated:YES];
}

- (void)doSomethingEvenMoreLater {
    [self.router executeCommand:[[PXDismissModal alloc] init] animated:YES];
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

#pragma mark - PXRouterDelegate

- (void)router:(LHRouter *)router nodeStateDidUpdate:(id<LHNode>)node {
}

@end
