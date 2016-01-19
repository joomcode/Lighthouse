//
//  RTRTabBarControllerDriver.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRTabBarControllerDriver.h"
#import "RTRDriverUpdateContext.h"
#import "RTRNodeChildrenState.h"
#import "RTRDriverFeedbackChannel.h"
#import "RTRViewControllerDriverHelpers.h"
#import "RTRNode.h"
#import "RTRTarget.h"

@interface RTRTabBarControllerDriver () <UITabBarControllerDelegate>

@property (nonatomic, strong) NSOrderedSet<id<RTRNode>> *childNodes;
@property (nonatomic, assign) NSInteger activeChildIndex;

@end


@implementation RTRTabBarControllerDriver

#pragma mark - Dealloc

- (void)dealloc {
    _data.delegate = nil;
}

#pragma mark - RTRDriver

@synthesize data = _data;
@synthesize feedbackChannel = _feedbackChannel;

- (void)updateWithContext:(id<RTRDriverUpdateContext>)context {
    if (!_data) {
        _data = [[UITabBarController alloc] init];
        _data.delegate = self;
    }
    
    NSAssert(context.childrenState.activeChildren.count == 1, @""); // TODO
    
    id<RTRNode> activeChild = context.childrenState.activeChildren.anyObject;
    
    self.childNodes = context.childrenState.initializedChildren;
    self.activeChildIndex = [self.childNodes indexOfObject:activeChild];
    
    NSArray<UIViewController *> *viewControllers = [RTRViewControllerDriverHelpers childViewControllersWithUpdateContext:context];
    
    [self.data setViewControllers:viewControllers animated:context.animated]; // TODO: use updateQueue
    [self.data setSelectedIndex:self.activeChildIndex];
}

#pragma mark - UITabBarBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    self.activeChildIndex = [tabBarController.viewControllers indexOfObject:viewController];

    [self.feedbackChannel startNodeUpdateWithBlock:^(id<RTRNode> node) {
        id<RTRNode> activeChild = self.childNodes[self.activeChildIndex];
        [node updateChildrenState:[RTRTarget withActiveNode:activeChild]];
    }];
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self.feedbackChannel finishNodeUpdate];
}

@end
