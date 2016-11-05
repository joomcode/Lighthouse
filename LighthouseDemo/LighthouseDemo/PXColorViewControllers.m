//
//  PXColorViewControllers.m
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "PXColorViewControllers.h"
#import "PXCommands.h"
#import "LHRouter+Shared.h"
#import <Lighthouse.h>

@implementation PXRedViewController

- (instancetype)init {
    self = [super init];
    self.title = @"Red";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    UIButton *showGreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [showGreenButton setTitle:@"Show Green" forState:UIControlStateNormal];
    [self.view addSubview:showGreenButton];
    
    [showGreenButton sizeToFit];
    showGreenButton.center = CGPointMake(self.view.center.x, self.view.center.y -30);
    
    [showGreenButton addTarget:self action:@selector(showGreenPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *showBlueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [showBlueButton setTitle:@"Show Blue" forState:UIControlStateNormal];
    [self.view addSubview:showBlueButton];
    
    [showBlueButton sizeToFit];
    showBlueButton.center = CGPointMake(self.view.center.x, self.view.center.y + 30);
    
    [showBlueButton addTarget:self action:@selector(showBluePressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showGreenPressed {
    [[LHRouter sharedInstance] executeCommand:[PXPresentGreen new]];
}

- (void)showBluePressed {
    [[LHRouter sharedInstance] executeCommand:[PXPresentBlue new]];
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
    
    UIButton *showBlueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [showBlueButton setTitle:@"Show Blue" forState:UIControlStateNormal];
    [self.view addSubview:showBlueButton];
    
    [showBlueButton sizeToFit];
    showBlueButton.center = CGPointMake(self.view.center.x, self.view.center.y + 30);
    
    [showBlueButton addTarget:self action:@selector(showBluePressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showBluePressed {
    [[LHRouter sharedInstance] executeCommand:[PXPresentBlue new]];
}

@end


@interface PXBlueViewController ()

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

#pragma mark - LHUpdateHandler

- (void)awakeForLighthouseUpdateHandlingWithUpdateBus:(id<LHUpdateBus>)updateBus {
    [super awakeForLighthouseUpdateHandlingWithUpdateBus:updateBus];
    
    [updateBus addStateUpdateHandler:^(LHNodeState state) {
        if (state == LHNodeStateActive) {
            [self presentAlert];
        }
    }];
}

- (void)presentAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Hello there!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
