//
//  LHTabBarControllerDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHTabBarControllerDriver.h"
#import "LHTabNode.h"
#import "LHDriverChannel.h"
#import "LHDriverUpdateContext.h"
#import "LHTarget.h"
#import "LHViewControllerDriverHelpers.h"

@interface LHTabBarControllerDriver () <UITabBarControllerDelegate>

@property (nonatomic, strong, readonly) LHTabNode *node;
@property (nonatomic, strong, readonly) id<LHDriverChannel> channel;

@end


@implementation LHTabBarControllerDriver

#pragma mark - Init

- (instancetype)initWithNode:(LHTabNode *)node channel:(id<LHDriverChannel>)channel {
    self = [super init];
    if (!self) return nil;
    
    _node = node;
    _channel = channel;
    
    return self;
}

#pragma mark - Dealloc

- (void)dealloc {
    _data.delegate = nil;
}

#pragma mark - LHDriver

@synthesize data = _data;

- (UITabBarController *)data {
    if (!_data) {
        _data = [[UITabBarController alloc] init];
        _data.delegate = self;
    }
    return _data;
}

- (void)updateWithContext:(id<LHDriverUpdateContext>)context {
    NSArray<UIViewController *> *childViewControllers =
        [LHViewControllerDriverHelpers viewControllersForNodes:self.node.orderedChildren withUpdateContext:context];
    
    if (![childViewControllers isEqualToArray:self.data.viewControllers]) {
        [self.data setViewControllers:childViewControllers animated:context.animated]; // TODO: use updateQueue
    }
    
    if (self.data.selectedIndex != self.node.childrenState.activeChildIndex) {
        [self.data setSelectedIndex:self.node.childrenState.activeChildIndex];
    }
}

- (void)presentationStateDidChange:(LHNodePresentationState)presentationState {
}

#pragma mark - UITabBarBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    [self.channel startNodeUpdateWithBlock:^(id<LHNode> node) {
        NSUInteger activeChildIndex = [tabBarController.viewControllers indexOfObject:viewController];
        id<LHNode> activeChild = self.node.orderedChildren[activeChildIndex];
        
        [node updateChildrenState:[LHTarget withActiveNode:activeChild]];
    }];
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self.channel finishNodeUpdate];
}

@end
