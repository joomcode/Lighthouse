//
//  LHModalTransitionContext.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 06/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHModalTransitionContext.h"

@implementation LHModalTransitionContext

- (instancetype)initWithSourceViewController:(UIViewController *)sourceViewController
                   destinationViewController:(UIViewController *)destinationViewController
                    presentingViewController:(UIViewController *)presentingViewController
                viewControllerBeingPresented:(UIViewController *)viewControllerBeingPresented {
    self = [super init];
    if (!self) return nil;
    
    _sourceViewController = sourceViewController;
    _destinationViewController = destinationViewController;
    _presentingViewController = presentingViewController;
    _viewControllerBeingPresented = viewControllerBeingPresented;
    
    return self;
}

@end
