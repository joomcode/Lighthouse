//
//  LHNavigationControllerDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNavigationControllerDriver.h"
#import "LHDriverUpdateContext.h"
#import "LHNodeChildrenState.h"
#import "LHDriverFeedbackChannel.h"
#import "LHViewControllerDriverHelpers.h"
#import "LHTaskQueue.h"
#import "LHNode.h"
#import "LHTarget.h"

@interface LHNavigationControllerDriver () <UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray<id<LHNode>> *childNodes;

@end


@implementation LHNavigationControllerDriver

#pragma mark - Dealloc

- (void)dealloc {
    _data.delegate = nil;
}

#pragma mark - LHDriver

@synthesize data = _data;
@synthesize feedbackChannel = _feedbackChannel;

- (void)updateWithContext:(id<LHDriverUpdateContext>)context {
    if (!_data) {
        _data = [[UINavigationController alloc] init];
        _data.delegate = self;
    }
    
    NSAssert(context.childrenState.activeChildren.count <= 1, @""); // TODO
    NSAssert(context.childrenState.initializedChildren.lastObject == context.childrenState.activeChildren.anyObject, @""); // TODO
    
    NSArray<UIViewController *> *childViewControllers = [LHViewControllerDriverHelpers childViewControllersWithUpdateContext:context];
    
    if ([childViewControllers isEqual:_data.viewControllers]) {
        return;
    }
    
    self.childNodes = [context.childrenState.initializedChildren.array copy];
    
    [context.updateQueue runAsyncTaskWithBlock:^(LHTaskCompletionBlock completion) {
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
    
    NSArray<id<LHNode>> *oldChildNodes = self.childNodes;
    
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
    
    [self.feedbackChannel startNodeUpdateWithBlock:^(id<LHNode> node) {
        [node updateChildrenState:[LHTarget withActiveNode:self.childNodes.lastObject]];
    }];
}

@end
