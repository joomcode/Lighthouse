//
//  RTRNavigationControllerDriver.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNavigationControllerDriver.h"
#import "RTRDriverUpdateContext.h"
#import "RTRNodeChildrenState.h"
#import "RTRDriverFeedbackChannel.h"
#import "RTRViewControllerDriverHelpers.h"
#import "RTRTaskQueue.h"
#import "RTRNode.h"
#import "RTRTarget.h"

@interface RTRNavigationControllerDriver () <UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray<id<RTRNode>> *childNodes;

@end


@implementation RTRNavigationControllerDriver

#pragma mark - Dealloc

- (void)dealloc {
    _data.delegate = nil;
}

#pragma mark - RTRDriver

@synthesize data = _data;
@synthesize feedbackChannel = _feedbackChannel;

- (void)updateWithContext:(id<RTRDriverUpdateContext>)context {
    if (!_data) {
        _data = [[UINavigationController alloc] init];
        _data.delegate = self;
    }
    
    NSAssert(context.childrenState.activeChildren.count <= 1, @""); // TODO
    NSAssert(context.childrenState.initializedChildren.lastObject == context.childrenState.activeChildren.anyObject, @""); // TODO
    
    NSArray<UIViewController *> *childViewControllers = [RTRViewControllerDriverHelpers childViewControllersWithUpdateContext:context];
    
    if ([childViewControllers isEqual:_data.viewControllers]) {
        return;
    }
    
    self.childNodes = [context.childrenState.initializedChildren.array copy];
    
    [context.updateQueue runAsyncTaskWithBlock:^(RTRTaskCompletionBlock completion) {
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
    
    NSArray<id<RTRNode>> *oldChildNodes = self.childNodes;
    
    [self startNodeUpdateWithChildNodes:[oldChildNodes subarrayWithRange:NSMakeRange(0, count)]];
    
    [navigationController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        if ([context isCancelled]) {
            [self startNodeUpdateWithChildNodes:oldChildNodes];
        }
    }];
    
    [navigationController.transitionCoordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.feedbackChannel finishNodeUpdate];
    }];
}

- (void)startNodeUpdateWithChildNodes:(NSArray *)childNodes {
    self.childNodes = childNodes;
    
    [self.feedbackChannel startNodeUpdateWithBlock:^(id<RTRNode> node) {
        [node updateChildrenState:[RTRTarget withActiveNode:self.childNodes.lastObject]];
    }];
}

@end
