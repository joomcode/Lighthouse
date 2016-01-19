//
//  LHTabBarControllerDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHTabBarControllerDriver.h"
#import "LHDriverUpdateContext.h"
#import "LHNodeChildrenState.h"
#import "LHDriverFeedbackChannel.h"
#import "LHViewControllerDriverHelpers.h"
#import "LHNode.h"
#import "LHTarget.h"

@interface LHTabBarControllerDriver () <UITabBarControllerDelegate>

@property (nonatomic, strong) NSOrderedSet<id<LHNode>> *childNodes;
@property (nonatomic, assign) NSInteger activeChildIndex;

@end


@implementation LHTabBarControllerDriver

#pragma mark - Dealloc

- (void)dealloc {
    _data.delegate = nil;
}

#pragma mark - LHDriver

@synthesize data = _data;
@synthesize feedbackChannel = _feedbackChannel;

- (void)updateWithContext:(id<LHDriverUpdateContext>)context {
    if (!_data) {
        _data = [[UITabBarController alloc] init];
        _data.delegate = self;
    }
    
    NSAssert(context.childrenState.activeChildren.count == 1, @""); // TODO
    
    id<LHNode> activeChild = context.childrenState.activeChildren.anyObject;
    
    self.childNodes = context.childrenState.initializedChildren;
    self.activeChildIndex = [self.childNodes indexOfObject:activeChild];
    
    NSArray<UIViewController *> *viewControllers = [LHViewControllerDriverHelpers childViewControllersWithUpdateContext:context];
    
    [self.data setViewControllers:viewControllers animated:context.animated]; // TODO: use updateQueue
    [self.data setSelectedIndex:self.activeChildIndex];
}

#pragma mark - UITabBarBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    self.activeChildIndex = [tabBarController.viewControllers indexOfObject:viewController];

    [self.feedbackChannel startNodeUpdateWithBlock:^(id<LHNode> node) {
        id<LHNode> activeChild = self.childNodes[self.activeChildIndex];
        [node updateChildrenState:[LHTarget withActiveNode:activeChild]];
    }];
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self.feedbackChannel finishNodeUpdate];
}

@end
