//
//  AppDelegate.m
//  RouterDemo
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
#import <Router.h>

@interface AppDelegate () <RTRRouterDelegate>

@property (nonatomic, strong) RTRRouter *router;

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
    
    RTRBasicDriverProvider *driverProvider = [[RTRBasicDriverProvider alloc] init];
    
    [driverProvider bindNode:hierarchy.rootNode toBlock:^id<RTRDriver>(id<RTRNode> node) {
        return [[RTRModalPresentationDriver alloc] initWithWindow:self.window];
    }];
    
    [driverProvider bindNodeClass:[RTRStackNode class] toBlock:^id<RTRDriver>(id<RTRNode> node) {
        return [[RTRNavigationControllerDriver alloc] init];
    }];
    
    [driverProvider bindNodeClass:[RTRTabNode class] toBlock:^id<RTRDriver>(id<RTRNode> node) {
        return [[RTRTabBarControllerDriver alloc] init];
    }];
    
    [driverProvider bindNodes:@[ hierarchy.redNode, hierarchy.anotherRedNode ] toBlock:^id<RTRDriver>(id<RTRNode> node) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXRedViewController class]];
    }];
    
    [driverProvider bindNodes:@[ hierarchy.greenNode, hierarchy.anotherGreenNode ] toBlock:^id<RTRDriver>(id<RTRNode> node) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXGreenViewController class]];
    }];
    
    [driverProvider bindNodes:@[ hierarchy.blueNode, hierarchy.anotherBlueNode ] toBlock:^id<RTRDriver>(id<RTRNode> node) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXBlueViewController class]];
    }];
    
    [driverProvider bindNodes:@[ hierarchy.modalNode ] toBlock:^id<RTRDriver>(id<RTRNode> node) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXModalViewController class]];
    }];
    
    [driverProvider bindNode:hierarchy.deepModalNode toBlock:^id<RTRDriver>(id<RTRNode> node) {
        return [[PXStateViewControllerDriver alloc] initWithViewControllerClass:[PXDeepModalViewController class]];
    }];
    
    [driverProvider bindNode:hierarchy.alertNode toBlock:^id<RTRDriver>(id<RTRNode> node) {
        RTRUpdateOrientedDriver *driver = [[RTRUpdateOrientedDriver alloc] init];
        driver.defaultDataInitBlock = ^(id<RTRCommand> command, id<RTRUpdateHandler> updateHandler) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hello there!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];            
            
            return alertController;
        };
        return driver;
    }];


    // Command Registry
    
    RTRBasicCommandRegistry *commandRegistry = [[RTRBasicCommandRegistry alloc] init];
    
    [commandRegistry bindCommandClass:[PXPresentRed class] toTargetWithActiveNode:hierarchy.redNode];
    [commandRegistry bindCommandClass:[PXPresentGreen class] toTargetWithActiveNode:hierarchy.greenNode];
    [commandRegistry bindCommandClass:[PXPresentBlue class] toTargetWithActiveNode:hierarchy.blueNode];
    [commandRegistry bindCommandClass:[PXPresentModal class] toTargetWithActiveNode:hierarchy.deepModalNode];
    [commandRegistry bindCommandClass:[PXDismissModal class] toTarget:[RTRTarget withInactiveNodes:@[ hierarchy.modalStackNode, hierarchy.deepModalStackNode ]]];
    [commandRegistry bindCommandClass:[PXPresentAnotherModal class] toTargetWithActiveNode:hierarchy.anotherBlueNode];
    [commandRegistry bindCommandClass:[PXPresentAlert class] toTargetWithActiveNode:hierarchy.alertNode];

    
    // Router
    
    RTRRouter *router = [[RTRRouter alloc] init];
    router.rootNode = hierarchy.rootNode;
    router.driverProvider = driverProvider;
    router.commandRegistry = commandRegistry;
    router.delegate = self;
    
    self.router = router;
}

#pragma mark - Stuff

- (void)performStuff {
    [self doSomething];
    [self performSelector:@selector(doSomethingLater) withObject:nil afterDelay:3.0];
    [self performSelector:@selector(doSomethingEvenLater) withObject:nil afterDelay:6.0];
    [self performSelector:@selector(doSomethingEvenMoreLater) withObject:nil afterDelay:9.0];
    [self performSelector:@selector(doSomethingAfterAllThat) withObject:nil afterDelay:12.0];
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

- (void)doSomethingAfterAllThat {
    [self.router executeCommand:[[PXPresentAlert alloc] init] animated:YES];
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

- (void)router:(RTRRouter *)router nodeStateDidUpdate:(id<RTRNode>)node {
}

@end
