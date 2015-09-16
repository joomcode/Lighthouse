//
//  PXColorViewControllers.m
//  RouterDemo
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "PXColorViewControllers.h"

@implementation PXRedViewController

- (instancetype)init {
    self = [super init];
    self.title = @"Red";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

@end


@implementation PXGreenViewController

- (instancetype)init {
    self = [super init];
    self.title = @"Green";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
}

@end


@implementation PXBlueViewController

- (instancetype)init {
    self = [super init];
    self.title = @"Blue";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
}

@end