//
//  RTRModalPresentationContent.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRModalPresentationContent.h"
#import "RTRNodeContentUpdateContext.h"
#import "RTRTaskQueue.h"
#import "RTRNodeChildrenState.h"
#import "RTRViewControllerContentHelpers.h"

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
    NSAssert(updateContext.childrenState.activeChildren.count <= 1, @""); // TODO
    NSAssert(updateContext.childrenState.initializedChildren.lastObject == updateContext.childrenState.activeChildren.lastObject, @""); // TODO
    
    NSArray *viewControllers = [RTRViewControllerContentHelpers childViewControllersWithUpdateContext:updateContext];
    NSArray *presentedViewControllers = [self presentedViewControllers];
    
    NSInteger commonPrefixLength = [self commonPrefixLengthForArray:viewControllers andArray:presentedViewControllers];

    for (NSInteger i = presentedViewControllers.count - 1; i >= commonPrefixLength; --i) {
        if (i == 0) {
            continue;
        }
        
        UIViewController *viewController = presentedViewControllers[i - 1];
        
        [updateContext.updateQueue enqueueAsyncBlock:^(RTRTaskQueueAsyncCompletionBlock completion) {
            [viewController dismissViewControllerAnimated:updateContext.animated completion:completion];
        }];
    }
    
    for (NSInteger i = commonPrefixLength; i < viewControllers.count; ++i) {
        UIViewController *viewController = viewControllers[i];
        
        if (i == 0) {
            [updateContext.updateQueue enqueueBlock:^{
                self.window.rootViewController = viewController;
                
                if (self.window.hidden) {
                    [self.window makeKeyAndVisible];
                }
            }];
        } else {
            UIViewController *previousViewController = viewControllers[i - 1];
            
            [updateContext.updateQueue enqueueAsyncBlock:^(RTRTaskQueueAsyncCompletionBlock completion) {
                [previousViewController presentViewController:viewController animated:updateContext.animated completion:completion];
            }];
        }
    }
}

#pragma mark - Private

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
