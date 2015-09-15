//
//  PXColorViewControllers.m
//  RouterDemo
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "PXColorViewControllers.h"

@implementation PXRedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Red";
    self.view.backgroundColor = [UIColor redColor];
}

@end


@implementation PXGreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Green";
    self.view.backgroundColor = [UIColor greenColor];
}

@end


@implementation PXBlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Blue";
    self.view.backgroundColor = [UIColor blueColor];
}

@end