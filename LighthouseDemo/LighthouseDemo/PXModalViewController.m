//
//  PXModalViewController.m
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "PXModalViewController.h"

@implementation PXModalViewController

- (instancetype)init {
    self = [super init];
    self.title = @"Modal";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor magentaColor];
}

@end
