//
//  AppDelegate.m
//  RouterDemo
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "AppDelegate.h"
#import "RTRRouter+Shared.h"
#import "PXColorViewControllers.h"
#import "PXPresentRed.h"
#import "PXPresentGreen.h"
#import "PXPresentBlue.h"
#import <Router.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [self setupRouter];
    [[RTRRouter sharedInstance] executeCommand:[[PXPresentRed alloc] init] animated:NO];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupRouter {
    // Nodes
    
    id<RTRNode> redNode = [[RTRLeafNode alloc] init];
    id<RTRNode> greenNode = [[RTRLeafNode alloc] init];
    id<RTRNode> blueNode = [[RTRLeafNode alloc] init];
    
    RTRNodeTree *stackTree = [[RTRNodeTree alloc] init];
    [stackTree addNode:redNode afterNode:nil];
    [stackTree addNode:greenNode afterNode:redNode];
    [stackTree addNode:blueNode afterNode:greenNode];
    
    id<RTRNode> stackNode = [[RTRStackNode alloc] initWithTree:stackTree];
    
    id<RTRNode> rootNode = [[RTRLayerNode alloc] initWithRootNode:stackNode];
    
    
    // Node Content
    
    RTRBlockNodeContentProvider *nodeContentProvider = [[RTRBlockNodeContentProvider alloc] init];
    
    [nodeContentProvider bindNode:redNode toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRViewControllerContent alloc] initWithViewControllerClass:[PXRedViewController class]];
    }];
    
    [nodeContentProvider bindNode:greenNode toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRViewControllerContent alloc] initWithViewControllerClass:[PXGreenViewController class]];
    }];
    
    [nodeContentProvider bindNode:blueNode toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRViewControllerContent alloc] initWithViewControllerClass:[PXBlueViewController class]];
    }];
    
    [nodeContentProvider bindNode:stackNode toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRNavigationControllerContent alloc] init];
    }];
    
    [nodeContentProvider bindNode:rootNode toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRModalPresentationContent alloc] initWithWindow:self.window];
    }];


    // Command Registry
    
    RTRCommandRegistry *commandRegistry = [[RTRCommandRegistry alloc] init];
    
    [commandRegistry bindNode:redNode toCommandClass:[PXPresentRed class]];
    [commandRegistry bindNode:greenNode toCommandClass:[PXPresentGreen class]];
    [commandRegistry bindNode:blueNode toCommandClass:[PXPresentBlue class]];

    
    // Router
    
    RTRRouter *router = [RTRRouter sharedInstance];
    router.rootNode = rootNode;
    router.nodeContentProviders = @[ nodeContentProvider ];
    router.commandRegistry = commandRegistry;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
