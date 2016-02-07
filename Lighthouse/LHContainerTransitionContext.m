//
//  LHContainerTransitionContext.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 06/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHContainerTransitionContext.h"

@implementation LHContainerTransitionContext

- (instancetype)initWithSourceViewController:(UIViewController *)sourceViewController
                   destinationViewController:(UIViewController *)destinationViewController {
    self = [super init];
    if (!self) return nil;
    
    _sourceViewController = sourceViewController;
    _destinationViewController = destinationViewController;
    
    return self;
}

@end
