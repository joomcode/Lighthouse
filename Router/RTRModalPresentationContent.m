//
//  RTRModalPresentationContent.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRModalPresentationContent.h"
#import "RTRNodeContentUpdateContext.h"
#import "RTRNodeChildrenState.h"

@interface RTRModalPresentationContent ()

@property (nonatomic, readonly) UIWindow *window;

@end


@implementation RTRModalPresentationContent

#pragma mark - Init

- (instancetype)init {
    return [self initWithWindow:nil];
}

- (instancetype)initWithWindow:(UIWindow *)window {
    NSParameterAssert(window != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _window = window;
    
    return self;
}

#pragma mark - RTRNodeContent

@synthesize data = _data;

- (void)updateWithContext:(id<RTRNodeContentUpdateContext>)updateContext {
    NSArray *viewControllers = [self viewControllerStackWithUpdateContext:updateContext];
    NSArray *presentedViewControllers = [self presentedViewControllers];
    
    NSInteger commonPrefixLength = [self commonPrefixLengthForArray:viewControllers andArray:presentedViewControllers];
    
    for (NSInteger i = presentedViewControllers.count - 1; i >= commonPrefixLength; --i) {
        if (i > 0) {
            UIViewController *viewController = presentedViewControllers[i];
            [viewController.presentingViewController dismissViewControllerAnimated:updateContext.animated completion:nil];
        }
    }
    
    for (NSInteger i = commonPrefixLength; i < viewControllers.count; ++i) {
        UIViewController *viewController = viewControllers[i];
        
        if (i == 0) {
            self.window.rootViewController = viewController;
        } else {
            UIViewController *previousViewController = viewControllers[i - 1];
            [previousViewController presentViewController:viewController animated:updateContext.animated completion:nil];
        }
    }
}

#pragma mark - Private

- (NSArray *)viewControllerStackWithUpdateContext:(id<RTRNodeContentUpdateContext>)updateContext {
    NSAssert(updateContext.childrenState.activeChildren.count <= 1, nil); // TODO
    
    NSMutableArray *childNodes = [[updateContext.childrenState.initializedChildren array] mutableCopy];
    [childNodes addObject:updateContext.childrenState.activeChildren.firstObject];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:childNodes.count];
    
    for (id<RTRNode> childNode in childNodes) {
        id<RTRNodeContent> childContent = [updateContext contentForNode:childNode];
        NSAssert([childContent.data isKindOfClass:[UIViewController class]], nil); // TODO
        [viewControllers addObject:childContent.data];
    }
    
    return viewControllers;
}

- (NSArray *)presentedViewControllers {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    UIViewController *currentViewController = self.window.rootViewController;
    
    while (currentViewController) {
        [viewControllers addObject:currentViewController];
        currentViewController = currentViewController.presentedViewController;
    }
    
    return viewControllers;
}

- (NSInteger)commonPrefixLengthForArray:(NSArray *)array1 andArray:(NSArray *)array2 {
    NSInteger i = 0;
    while (i < array1.count && i < array2.count && [array1[i] isEqual:array2[i]]) {
        ++i;
    }
    return i;
}

@end
