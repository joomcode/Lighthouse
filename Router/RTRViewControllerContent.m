//
//  RTRViewControllerContent.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRViewControllerContent.h"

@interface RTRViewControllerContent ()

@property (nonatomic, strong) Class viewControllerClass;

@end


@implementation RTRViewControllerContent

- (instancetype)initWithViewControllerClass:(Class)viewControllerClass {
    self = [super init];
    if (!self) return nil;
    
    _viewControllerClass = viewControllerClass;
    
    return self;
}

#pragma mark - RTRNodeContent

@synthesize data = _data;

- (void)updateWithContext:(id<RTRNodeContentUpdateContext>)context {
    if (!_data) {
        _data = [[self.viewControllerClass alloc] init];
    }
}

@end
