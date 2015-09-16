//
//  AppDelegate.m
//  RouterDemo
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "AppDelegate.h"
#import "PXColorViewControllers.h"
#import "PXPresentRed.h"
#import "PXPresentGreen.h"
#import "PXPresentBlue.h"
#import "RTRRouter+Shared.h"
#import <Router.h>

@interface AppDelegate ()

@property (nonatomic, strong) RTRRouter *router;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [self setupRouter];
    [self.router executeCommand:[[PXPresentRed alloc] init] animated:NO];
    
    [self.window makeKeyAndVisible];
    
    [self performSelector:@selector(doSomething) withObject:nil afterDelay:3.0];
    
    return YES;
}

- (void)setupRouter {
    // Nodes
    
    id<RTRNode> redNode = [[RTRLeafNode alloc] init];
    id<RTRNode> greenNode = [[RTRLeafNode alloc] init];
    id<RTRNode> blueNode = [[RTRLeafNode alloc] init];
    
    RTRNodeTree *stackTree = [[RTRNodeTree alloc] init];
    [stackTree addNode:redNode afterNodeOrNil:nil];
    [stackTree addNode:greenNode afterNodeOrNil:redNode];
    [stackTree addNode:blueNode afterNodeOrNil:greenNode];
    
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
    
    self.router = router;
}

- (void)doSomething {
    [self.router executeCommand:[[PXPresentBlue alloc] init] animated:YES];
}

@end
