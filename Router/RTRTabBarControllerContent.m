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

@end


@implementation RTRTabBarControllerContent

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
    
    NSArray *viewControllers = [RTRViewControllerContentHelpers childViewControllersWithUpdateContext:updateContext];
    [self.data setViewControllers:viewControllers animated:updateContext.animated];
    
    id<RTRNode> activeChild = updateContext.childrenState.activeChildren.firstObject;
    [self.data setSelectedIndex:[updateContext.childrenState.initializedChildren indexOfObject:activeChild]];
    
    self.childNodes = updateContext.childrenState.initializedChildren;
}

#pragma mark - UITabBarBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self.feedbackChannel childNodeDidBecomeActive:self.childNodes[tabBarController.selectedIndex]];
}

@end
