//
//  RTRViewControllerDriver.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRViewControllerDriver.h"

@interface RTRViewControllerDriver ()

@property (nonatomic, strong) Class viewControllerClass;

@end


@implementation RTRViewControllerDriver

- (instancetype)initWithViewControllerClass:(Class)viewControllerClass {
    self = [super init];
    if (!self) return nil;
    
    _viewControllerClass = viewControllerClass;
    
    return self;
}

#pragma mark - RTRDriver

@synthesize data = _data;

- (void)updateWithContext:(id<RTRDriverUpdateContext>)context {
    if (!_data) {
        _data = [[self.viewControllerClass alloc] init];
    }
}

@end
