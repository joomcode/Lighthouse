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

@interface RTRTabBarControllerContent () <UITabBarControllerDelegate>

@property (nonatomic, strong) NSOrderedSet *childNodes;
@property (nonatomic, assign) NSInteger activeChildIndex;

@property (nonatomic, readonly) NSSet *activeChildNodes;

@end


@implementation RTRTabBarControllerContent

#pragma mark - Nodes

- (NSSet *)activeChildNodes {
    return [NSSet setWithObject:self.childNodes[self.activeChildIndex]];
}

#pragma mark - Dealloc

- (void)dealloc {
    _data.delegate = nil;
}

#pragma mark - RTRNodeContent

@synthesize data = _data;
@synthesize feedbackChannel = _feedbackChannel;

- (void)updateWithContext:(id<RTRNodeContentUpdateContext>)updateContext {
    if (!_data) {
        _data = [[UITabBarController alloc] init];
        _data.delegate = self;
    }
    
    NSAssert(updateContext.childrenState.activeChildren.count == 1, @""); // TODO
    
    id<RTRNode> activeChild = updateContext.childrenState.activeChildren.firstObject;
    
    self.childNodes = updateContext.childrenState.initializedChildren;
    self.activeChildIndex = [self.childNodes indexOfObject:activeChild];
    
    NSArray *viewControllers = [RTRViewControllerContentHelpers childViewControllersWithUpdateContext:updateContext];
    
    [self.data setViewControllers:viewControllers animated:updateContext.animated]; // TODO: use updateQueue
    [self.data setSelectedIndex:self.activeChildIndex];
}

#pragma mark - UITabBarBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    self.activeChildIndex = [tabBarController.viewControllers indexOfObject:viewController];
    
    [self.feedbackChannel childNodesWillBecomeActive:self.activeChildNodes];
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self.feedbackChannel childNodesDidBecomeActive:self.activeChildNodes];
}

@end
