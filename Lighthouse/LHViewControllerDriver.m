//
//  LHViewControllerDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHViewControllerDriver.h"

@interface LHViewControllerDriver ()

@property (nonatomic, strong) Class viewControllerClass;

@end


@implementation LHViewControllerDriver

- (instancetype)initWithViewControllerClass:(Class)viewControllerClass {
    self = [super init];
    if (!self) return nil;
    
    _viewControllerClass = viewControllerClass;
    
    return self;
}

#pragma mark - LHDriver

@synthesize data = _data;

- (void)updateWithContext:(LHDriverUpdateContext *)context {
    if (!_data) {
        _data = [[self.viewControllerClass alloc] init];
    }
}

- (void)stateDidChange:(LHNodeState)state {
}

@end
