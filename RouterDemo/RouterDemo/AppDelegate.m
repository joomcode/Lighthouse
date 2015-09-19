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
#import "PXDeepModalViewController.h"
#import "PXPresentRed.h"
#import "PXPresentGreen.h"
#import "PXPresentBlue.h"
#import "PXPresentModal.h"
#import "PXPresentAnotherModal.h"
#import "PXPresentAlert.h"
#import "RTRRouter+Shared.h"
#import <Router.h>

@interface AppDelegate () <RTRRouterDelegate>

@property (nonatomic, strong) RTRRouter *router;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [self setupRouter];
    
    [self doSomething];
    [self performSelector:@selector(doSomethingLater) withObject:nil afterDelay:3.0];
    [self performSelector:@selector(doSomethingEvenLater) withObject:nil afterDelay:6.0];
    [self performSelector:@selector(doSomethingEvenMoreLater) withObject:nil afterDelay:9.0];
    [self performSelector:@selector(doSomethingAfterAllThat) withObject:nil afterDelay:12.0];
    
    return YES;
}

- (void)setupRouter {
    // Nodes
    
    id<RTRNode> redNode = [[RTRLeafNode alloc] init];
    id<RTRNode> greenNode = [[RTRLeafNode alloc] init];
    id<RTRNode> blueNode = [[RTRLeafNode alloc] init];
    id<RTRNode> mainStackNode = [[RTRStackNode alloc] initWithSingleBranch:@[ redNode, greenNode, blueNode ]];
    
    id<RTRNode> modalNode = [[RTRLeafNode alloc] init];
    id<RTRNode> modalStackNode = [[RTRStackNode alloc] initWithSingleBranch:@[ modalNode ]];
    
    id<RTRNode> deepModalNode = [[RTRLeafNode alloc] init];
    id<RTRNode> deepModalStackNode = [[RTRStackNode alloc] initWithSingleBranch:@[ deepModalNode ]];
    
    id<RTRNode> anotherRedNode = [[RTRLeafNode alloc] init];
    id<RTRNode> anotherGreenNode = [[RTRLeafNode alloc] init];
    id<RTRNode> anotherBlueNode = [[RTRLeafNode alloc] init];
    NSArray *anotherTabNodes = @[ anotherRedNode, anotherGreenNode, anotherBlueNode ];
    id<RTRNode> anotherTabNode = [[RTRTabNode alloc] initWithChildren:[NSOrderedSet orderedSetWithArray:anotherTabNodes]];
    id<RTRNode> anotherModalStackNode = [[RTRStackNode alloc] initWithSingleBranch:@[ anotherTabNode ]];
    
    id<RTRNode> alertNode = [[RTRLeafNode alloc] init];
    
    RTRNodeTree *rootTree = [[RTRNodeTree alloc] init];
    [rootTree addBranch:@[ mainStackNode, modalStackNode, deepModalStackNode ] afterItemOrNil:nil];
    [rootTree addItem:anotherModalStackNode afterItemOrNil:mainStackNode];
    
    RTRNodeTree *alertTree = [[RTRNodeTree alloc] init];
    [alertTree addBranch:@[ alertNode ] afterItemOrNil:nil];
    
    RTRNodeForest *rootForest = [[RTRNodeForest alloc] init];
    [rootForest addBranch:@[ rootTree, alertTree ] afterItemOrNil:nil];
    
    id<RTRNode> rootNode = [[RTRStackNode alloc] initWithForest:rootForest];
    
    
    // Node Content
    
    RTRBasicNodeContentProvider *nodeContentProvider = [[RTRBasicNodeContentProvider alloc] init];
    
    [nodeContentProvider bindNodeClass:[RTRStackNode class] toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRNavigationControllerContent alloc] init];
    }];
    
    [nodeContentProvider bindNodeClass:[RTRTabNode class] toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRTabBarControllerContent alloc] init];
    }];
    
    [nodeContentProvider bindNodes:@[ redNode, anotherRedNode ] toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRViewControllerContent alloc] initWithViewControllerClass:[PXRedViewController class]];
    }];
    
    [nodeContentProvider bindNodes:@[ greenNode, anotherGreenNode ] toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRViewControllerContent alloc] initWithViewControllerClass:[PXGreenViewController class]];
    }];
    
    [nodeContentProvider bindNodes:@[ blueNode, anotherBlueNode ] toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRViewControllerContent alloc] initWithViewControllerClass:[PXBlueViewController class]];
    }];
    
    [nodeContentProvider bindNode:modalNode toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRViewControllerContent alloc] initWithViewControllerClass:[PXModalViewController class]];
    }];
    
    [nodeContentProvider bindNode:deepModalNode toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRViewControllerContent alloc] initWithViewControllerClass:[PXDeepModalViewController class]];
    }];
    
    [nodeContentProvider bindNode:alertNode toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRViewControllerContent alloc] initWithViewControllerClass:[PXModalViewController class]];
    }];
    
    [nodeContentProvider bindNode:rootNode toBlock:^id<RTRNodeContent>(id<RTRNode> node) {
        return [[RTRModalPresentationContent alloc] initWithWindow:self.window];
    }];


    // Command Registry
    
    RTRBasicCommandRegistry *commandRegistry = [[RTRBasicCommandRegistry alloc] init];
    
    [commandRegistry bindCommandClass:[PXPresentRed class] toNode:redNode];
    [commandRegistry bindCommandClass:[PXPresentGreen class] toNode:greenNode];
    [commandRegistry bindCommandClass:[PXPresentBlue class] toNode:blueNode];
    [commandRegistry bindCommandClass:[PXPresentModal class] toNode:deepModalNode];
    [commandRegistry bindCommandClass:[PXPresentAnotherModal class] toNode:anotherBlueNode];
    [commandRegistry bindCommandClass:[PXPresentAlert class] toNode:alertNode];

    
    // Router
    
    RTRRouter *router = [RTRRouter sharedInstance];
    router.rootNode = rootNode;
    router.nodeContentProvider = nodeContentProvider;
    router.commandRegistry = commandRegistry;
    router.delegate = self;
    
    self.router = router;
}

- (void)doSomething {
    [self.router executeCommand:[[PXPresentGreen alloc] init] animated:NO];
}

- (void)doSomethingLater {
    [self.router executeCommand:[[PXPresentAnotherModal alloc] init] animated:YES];
}

- (void)doSomethingEvenLater {
    [self.router executeCommand:[[PXPresentModal alloc] init] animated:YES];
}

- (void)doSomethingEvenMoreLater {
    [self.router executeCommand:[[PXPresentBlue alloc] init] animated:YES];
}

- (void)doSomethingAfterAllThat {
    id<RTRCommand> dismissCommand = (id<RTRCommand>)[[NSObject alloc] init]; // duh
    [self.router bindCommandToActiveNodes:dismissCommand];
    
    [self.router executeCommand:[[PXPresentAlert alloc] init] animated:YES];
    [self.router executeCommand:dismissCommand animated:YES];
}

//- (void)doSomething {
//    [self.router executeCommand:[[PXPresentRed alloc] init] animated:NO];
//}
//
//- (void)doSomethingLater {
//    [self.router executeCommand:[[PXPresentBlue alloc] init] animated:YES];
//}
//
//- (void)doSomethingEvenLater {
//    [self.router executeCommand:[[PXPresentGreen alloc] init] animated:YES];
//}
//
//- (void)doSomethingEvenMoreLater {
//    [self.router executeCommand:[[PXPresentRed alloc] init] animated:YES];
//}
//
//- (void)doSomethingAfterAllThat {
//    [self.router executeCommand:[[PXPresentGreen alloc] init] animated:YES];
//}

#pragma mark - PXRouterDelegate

- (void)routerNodeStateDidUpdate:(RTRRouter *)router {
}

@end
