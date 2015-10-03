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
#import "RTRNode.h"
#import "RTRTargetNodes.h"

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

- (void)updateWithContext:(id<RTRNodeContentUpdateContext>)context {
    if (!_data) {
        _data = [[UINavigationController alloc] init];
        _data.delegate = self;
    }
    
    NSAssert(context.childrenState.activeChildren.count <= 1, @""); // TODO
    NSAssert(context.childrenState.initializedChildren.lastObject == context.childrenState.activeChildren.lastObject, @""); // TODO
    
    NSArray *childViewControllers = [RTRViewControllerContentHelpers childViewControllersWithUpdateContext:context];
    
    if ([childViewControllers isEqual:_data.viewControllers]) {
        return;
    }
    
    [context.updateQueue runAsyncTaskWithBlock:^(RTRTaskCompletionBlock completion) {
        self.childNodes = [context.childrenState.initializedChildren.array copy];
        
        [self.data setViewControllers:childViewControllers animated:context.animated];
        
        if (context.animated) {
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
    self.childNodes = [oldChildNodes subarrayWithRange:NSMakeRange(0, count)];
    
    [self startNodeUpdate];
    
    [navigationController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled]) {
            self.childNodes = oldChildNodes;
            
            [self startNodeUpdate];
        }
    }];
    
    [navigationController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.feedbackChannel finishNodeUpdate];
    }];
}

- (void)startNodeUpdate {
    [self.feedbackChannel startNodeUpdateWithBlock:^(id<RTRNode> node) {
        [node updateChildrenState:[[RTRTargetNodes alloc] initWithActiveNode:self.childNodes.lastObject]];
    }];
}

@end
