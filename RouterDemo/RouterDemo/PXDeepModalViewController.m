//
//  PXDeepModalViewController.m
//  RouterDemo
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "PXDeepModalViewController.h"

@implementation PXDeepModalViewController

- (instancetype)initWithUpdateHandler:(id<RTRUpdateHandler>)updateHandler {
    self = [super initWithUpdateHandler:updateHandler];
    self.title = @"Deep Modal";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
}

@end
