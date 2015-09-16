//
//  AppDelegate.m
//  RouterDemo
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "AppDelegate.h"
#import "PXColorViewControllers.h"
#import "PXModalViewController.h"
#import "PXPresentRed.h"
#import "PXPresentGreen.h"
#import "PXPresentBlue.h"
#import "PXPresentModal.h"
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
    [self doSomething];
    [self performSelector:@selector(doSomethingLater) withObject:nil afterDelay:3.0];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setupRouter {
    // Nodes
    
    id<RTRNode> redNode = [[RTRLeafNode alloc] init];
    id<RTRNode> greenNode = [[RTRLeafNode alloc] init];
    id<RTRNode> blueNode = [[RTRLeafNode alloc] init];
    
    RTRNodeTree *mainTree = [[RTRNodeTree alloc] init];
    [mainTree addBranch:@[ redNode, greenNode, blueNode ] afterNodeOrNil:nil];
    
    id<RTRNode> mainStackNode = [[RTRStackNode alloc] initWithTree:mainTree];
    
    
    id<RTRNode> modalNode = [[RTRLeafNode alloc] init];
    
    RTRNodeTree *modalTree = [[RTRNodeTree alloc] init];
    [modalTree addNode:modalNode afterNodeOrNil:nil];
    
    id<RTRNode> modalStackNode = [[RTRStackNode alloc] initWithTree:modalTree];
    
    
    RTRNodeTree *rootTree = [[RTRNodeTree alloc] init];
    [rootTree addBranch:@[ mainStackNode, modalStackNode ] afterNodeOrNil:nil];
    
    id<RTRNode> rootNode = [[RTRStackNode alloc] initWithTree:rootTree];
    
    
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
    
    [nodeContentProvider bindNode:modalNode toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRViewControllerContent alloc] initWithViewControllerClass:[PXModalViewController class]];
    }];
    
    [nodeContentProvider bindNodeClass:[RTRStackNode class] toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
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
    [commandRegistry bindNode:modalNode toCommandClass:[PXPresentModal class]];

    
    // Router
    
    RTRRouter *router = [RTRRouter sharedInstance];
    router.rootNode = rootNode;
    router.nodeContentProvider = nodeContentProvider;
    router.commandRegistry = commandRegistry;
    
    self.router = router;
}

- (void)doSomething {
    [self.router executeCommand:[[PXPresentRed alloc] init] animated:NO];
}

- (void)doSomethingLater {
    [self.router executeCommand:[[PXPresentModal alloc] init] animated:YES];
}

@end
