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

@interface RTRNavigationControllerContent () <UINavigationControllerDelegate>

@property (nonatomic, strong) NSArray *childNodes;

@end

@implementation RTRNavigationControllerContent

#pragma mark - RTRNodeContent

@synthesize data = _data;
@synthesize feedbackChannel = _feedbackChannel;

- (void)setupDataWithCommand:(id<RTRCommand>)command {
    if (!_data) {
        _data = [[UINavigationController alloc] init];
        _data.delegate = self;
    }
}

- (void)performUpdateWithContext:(id<RTRNodeContentUpdateContext>)updateContext {
    NSAssert(updateContext.childrenState.activeChildren.count <= 1, nil); // TODO
    
    NSMutableArray *childNodes = [[updateContext.childrenState.initializedChildren array] mutableCopy];
    [childNodes addObject:updateContext.childrenState.activeChildren.firstObject];
    
    NSMutableArray *childViewControllers = [NSMutableArray arrayWithCapacity:childNodes.count];
    
    for (id<RTRNode> childNode in childNodes) {
        id<RTRNodeContent> childContent = [updateContext contentForNode:childNode];
        NSAssert([childContent.data isKindOfClass:[UIViewController class]], nil); // TODO
        [childViewControllers addObject:childContent.data];
    }
    
    [self.data setViewControllers:childViewControllers animated:updateContext.animated];
    
    self.childNodes = [childNodes copy];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // Handle pop prompted by the default Back button or gesture
    
    NSUInteger count = [navigationController.viewControllers count];
    if (count < [self.childNodes count]) {
        NSArray *oldChildNodes = self.childNodes;
        
        self.childNodes = [self.childNodes subarrayWithRange:NSMakeRange(0, count)];
        [self.feedbackChannel childNodeDidBecomeActive:self.childNodes.lastObject];
        
        [navigationController.transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
            if ([context isCancelled]) {
                self.childNodes = oldChildNodes;
                [self.feedbackChannel childNodeDidBecomeActive:self.childNodes.lastObject];
            }
        }];
    }
}

@end
