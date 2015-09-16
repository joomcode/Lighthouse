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
#import "RTRViewControllerContentHelpers.h"

typedef void (^RTRModalPresentationContentUpdateCompletionBlock)();
typedef void (^RTRModalPresentationContentUpdateBlock)(RTRModalPresentationContentUpdateCompletionBlock completion);


@interface RTRModalPresentationContent ()

@property (nonatomic, readonly) UIWindow *window;

@property (nonatomic, strong) NSMutableArray *updateBlocks;
@property (nonatomic, assign) BOOL updateInProgress;

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
    _updateBlocks = [[NSMutableArray alloc] init];
    
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
        if (i > 0) {
            UIViewController *viewController = presentedViewControllers[i];
            
            [self enqueueUpdateWithBlock:^(RTRModalPresentationContentUpdateCompletionBlock completion) {
                [viewController.presentingViewController dismissViewControllerAnimated:updateContext.animated completion:completion];
            }];
        }
    }
    
    for (NSInteger i = commonPrefixLength; i < viewControllers.count; ++i) {
        UIViewController *viewController = viewControllers[i];
        
        if (i == 0) {
            [self enqueueUpdateWithBlock:^(RTRModalPresentationContentUpdateCompletionBlock completion) {
                self.window.rootViewController = viewController;
                
                if (self.window.hidden) {
                    [self.window makeKeyAndVisible];
                }
                
                completion();
            }];
        } else {
            UIViewController *previousViewController = viewControllers[i - 1];
            
            [self enqueueUpdateWithBlock:^(RTRModalPresentationContentUpdateCompletionBlock completion) {
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

- (void)enqueueUpdateWithBlock:(RTRModalPresentationContentUpdateBlock)updateBlock {
    [self.updateBlocks addObject:updateBlock];
    [self dequeueUpdateIfPossible];
}

- (void)dequeueUpdateIfPossible {
    if (self.updateInProgress || self.updateBlocks.count == 0) {
        return;
    }
    
    self.updateInProgress = YES;
    
    RTRModalPresentationContentUpdateBlock updateBlock = self.updateBlocks[0];
    [self.updateBlocks removeObjectAtIndex:0];
    
    updateBlock(^{
        self.updateInProgress = NO;
        [self dequeueUpdateIfPossible];
    });
}

@end
