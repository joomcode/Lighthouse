//
//  PXColorViewControllers.m
//  RouterDemo
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "PXColorViewControllers.h"

@implementation PXRedViewController

- (instancetype)initWithUpdateHandler:(id<RTRUpdateHandler>)updateHandler {
    self = [super initWithUpdateHandler:updateHandler];
    self.title = @"Red";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

@end


@implementation PXGreenViewController

- (instancetype)initWithUpdateHandler:(id<RTRUpdateHandler>)updateHandler {
    self = [super initWithUpdateHandler:updateHandler];
    self.title = @"Green";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
}

@end


@implementation PXBlueViewController

- (instancetype)initWithUpdateHandler:(id<RTRUpdateHandler>)updateHandler {
    self = [super initWithUpdateHandler:updateHandler];
    self.title = @"Blue";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
}

@end