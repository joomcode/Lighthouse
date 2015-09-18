//
//  RTRNavigationControllerContent.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNavigationControllerContent.h"
#import "RTRNodeContentUpdateContext.h"
#import "RTRNodeChildrenState.h"
#import "RTRNodeContentFeedbackChannel.h"
#import "RTRViewControllerContentHelpers.h"
#import "RTRTaskQueue.h"

@interface RTRNavigationControllerContent () <UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *childNodes;

@end


@implementation RTRNavigationControllerContent

#pragma mark - Dealloc

- (void)dealloc {
    _data.delegate = nil;
}

#pragma mark - RTRNodeContent

@synthesize data = _data;
@synthesize feedbackChannel = _feedbackChannel;

- (void)updateWithContext:(id<RTRNodeContentUpdateContext>)updateContext {
    if (!_data) {
        _data = [[UINavigationController alloc] init];
        _data.delegate = self;
    }
    
    NSAssert(updateContext.childrenState.activeChildren.count <= 1, @""); // TODO
    NSAssert(updateContext.childrenState.initializedChildren.lastObject == updateContext.childrenState.activeChildren.lastObject, @""); // TODO
    
    NSArray *childViewControllers = [RTRViewControllerContentHelpers childViewControllersWithUpdateContext:updateContext];
    
    if ([childViewControllers isEqual:_data.viewControllers]) {
        return;
    }
    
    [updateContext.updateQueue runAsyncTaskWithBlock:^(RTRTaskQueueAsyncCompletionBlock completion) {
        self.childNodes = [updateContext.childrenState.initializedChildren.array copy];
        
        [self.data setViewControllers:childViewControllers animated:updateContext.animated];
        
        if (updateContext.animated) {
            UIViewController *topChildViewController = childViewControllers.lastObject;
            [topChildViewController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                completion();
            }];
        } else {
            completion();
        }
    }];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Handle pop prompted by the default Back button or gesture
    
    NSUInteger count = [navigationController.viewControllers count];
    if (count >= [self.childNodes count]) {
        return;
    }
    
    NSArray *oldChildNodes = self.childNodes;
    
    self.childNodes = [self.childNodes subarrayWithRange:NSMakeRange(0, count)];
    [self.feedbackChannel childNodeWillBecomeActive:self.childNodes.lastObject];
    
    [navigationController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled]) {
            self.childNodes = oldChildNodes;
            [self.feedbackChannel childNodeWillBecomeActive:self.childNodes.lastObject];
        }
    }];
    
    [navigationController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.feedbackChannel childNodeDidBecomeActive:self.childNodes.lastObject];
    }];
}

@end
