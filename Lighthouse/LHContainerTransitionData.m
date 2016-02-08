//
//  LHContainerTransitionData.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 07/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHContainerTransitionData.h"
#import "LHContainerTransitionStyle.h"
#import "LHTransitionContext.h"

@interface LHContainerTransitionData ()

@property (nonatomic, strong, readonly) id<LHContainerTransitionStyle> style;
@property (nonatomic, strong, readonly) LHTransitionContext *context;

@end


@implementation LHContainerTransitionData

#pragma mark - Init

- (instancetype)initWithStyle:(id<LHContainerTransitionStyle>)style context:(LHTransitionContext *)context {
    self = [super init];
    if (!self) return nil;
    
    _style = style;
    _context = context;
    
    return self;
}

#pragma mark - Public

- (id<UIViewControllerAnimatedTransitioning>)animationController {
    return [self.style animationControllerForContext:self.context];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionController {
    return [self.style interactionControllerForContext:self.context];
}

@end
