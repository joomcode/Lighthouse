//
//  RTRTabBarControllerContent.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRTabBarControllerContent.h"
#import "RTRNodeContentUpdateContext.h"
#import "RTRNodeChildrenState.h"
#import "RTRNodeContentFeedbackChannel.h"
#import "RTRViewControllerContentHelpers.h"
#import "RTRNode.h"
#import "RTRTarget.h"

@interface RTRTabBarControllerContent () <UITabBarControllerDelegate>

@property (nonatomic, strong) NSOrderedSet *childNodes;
@property (nonatomic, assign) NSInteger activeChildIndex;

@end


@implementation RTRTabBarControllerContent

#pragma mark - Dealloc

- (void)dealloc {
    _data.delegate = nil;
}

#pragma mark - RTRNodeContent

@synthesize data = _data;
@synthesize feedbackChannel = _feedbackChannel;

- (void)updateWithContext:(id<RTRNodeContentUpdateContext>)context {
    if (!_data) {
        _data = [[UITabBarController alloc] init];
        _data.delegate = self;
    }
    
    NSAssert(context.childrenState.activeChildren.count == 1, @""); // TODO
    
    id<RTRNode> activeChild = context.childrenState.activeChildren.firstObject;
    
    self.childNodes = context.childrenState.initializedChildren;
    self.activeChildIndex = [self.childNodes indexOfObject:activeChild];
    
    NSArray *viewControllers = [RTRViewControllerContentHelpers childViewControllersWithUpdateContext:context];
    
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
