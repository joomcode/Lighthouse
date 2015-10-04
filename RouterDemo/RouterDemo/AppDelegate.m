//
//  AppDelegate.m
//  RouterDemo
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "AppDelegate.h"
#import "PXStateDisplayingViewControllerContent.h"
#import "PXColorViewControllers.h"
#import "PXModalViewController.h"
#import "PXDeepModalViewController.h"
#import "PXPresentRed.h"
#import "PXPresentGreen.h"
#import "PXPresentBlue.h"
#import "PXPresentModal.h"
#import "PXPresentAnotherModal.h"
#import "PXPresentAlert.h"
#import "PXDismissAlert.h"
#import "PXNodeHierarchy.h"
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
    
    
    // Node Content
    
    RTRBasicNodeContentProvider *nodeContentProvider = [[RTRBasicNodeContentProvider alloc] init];
    
    [nodeContentProvider bindNode:hierarchy.rootNode toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRModalPresentationContent alloc] initWithWindow:self.window];
    }];
    
    [nodeContentProvider bindNodeClass:[RTRStackNode class] toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRNavigationControllerContent alloc] init];
    }];
    
    [nodeContentProvider bindNodeClass:[RTRTabNode class] toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRTabBarControllerContent alloc] init];
    }];
    
    [nodeContentProvider bindNodes:@[ hierarchy.redNode, hierarchy.anotherRedNode ] toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[PXStateDisplayingViewControllerContent alloc] initWithViewControllerClass:[PXRedViewController class]];
    }];
    
    [nodeContentProvider bindNodes:@[ hierarchy.greenNode, hierarchy.anotherGreenNode ] toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[PXStateDisplayingViewControllerContent alloc] initWithViewControllerClass:[PXGreenViewController class]];
    }];
    
    [nodeContentProvider bindNodes:@[ hierarchy.blueNode, hierarchy.anotherBlueNode ] toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[PXStateDisplayingViewControllerContent alloc] initWithViewControllerClass:[PXBlueViewController class]];
    }];
    
    [nodeContentProvider bindNodes:@[ hierarchy.modalNode, hierarchy.alertNode ] toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[PXStateDisplayingViewControllerContent alloc] initWithViewControllerClass:[PXModalViewController class]];
    }];
    
    [nodeContentProvider bindNode:hierarchy.deepModalNode toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[PXStateDisplayingViewControllerContent alloc] initWithViewControllerClass:[PXDeepModalViewController class]];
    }];


    // Command Registry
    
    RTRBasicCommandRegistry *commandRegistry = [[RTRBasicCommandRegistry alloc] init];
    
    [commandRegistry bindCommandClass:[PXPresentRed class] toActiveNodeTarget:hierarchy.redNode];
    [commandRegistry bindCommandClass:[PXPresentGreen class] toActiveNodeTarget:hierarchy.greenNode];
    [commandRegistry bindCommandClass:[PXPresentBlue class] toActiveNodeTarget:hierarchy.blueNode];
    [commandRegistry bindCommandClass:[PXPresentModal class] toActiveNodeTarget:hierarchy.deepModalNode];
    [commandRegistry bindCommandClass:[PXPresentAnotherModal class] toActiveNodeTarget:hierarchy.anotherBlueNode];
    [commandRegistry bindCommandClass:[PXPresentAlert class] toActiveNodeTarget:hierarchy.alertNode];
    [commandRegistry bindCommandClass:[PXDismissAlert class] toInactiveNodeTarget:hierarchy.alertNode];

    
    // Router
    
    RTRRouter *router = [[RTRRouter alloc] init];
    router.rootNode = hierarchy.rootNode;
    router.nodeContentProvider = nodeContentProvider;
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
    [self performSelector:@selector(doSomethingAfterAllThatToo) withObject:nil afterDelay:15.0];
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
    [self.router executeCommand:[[PXPresentBlue alloc] init] animated:YES];
}

- (void)doSomethingAfterAllThat {
    [self.router executeCommand:[[PXPresentAlert alloc] init] animated:YES];
}

- (void)doSomethingAfterAllThatToo {
    [self.router executeCommand:[[PXDismissAlert alloc] init] animated:YES];
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

- (void)routerNodeStateDidUpdate:(RTRRouter *)router {
}

@end
