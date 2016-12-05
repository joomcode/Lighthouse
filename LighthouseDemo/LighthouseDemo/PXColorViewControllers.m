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
    
    UIButton *showBlueThroughGreenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [showBlueThroughGreenButton setTitle:@"Show Blue Through Green" forState:UIControlStateNormal];
    [self.view addSubview:showBlueThroughGreenButton];
    
    [showBlueThroughGreenButton sizeToFit];
    showBlueThroughGreenButton.center = CGPointMake(self.view.center.x, self.view.center.y + 60);
    
    [showBlueThroughGreenButton addTarget:self action:@selector(showBlueThroughGreenPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showGreenPressed {
    [[LHRouter sharedInstance] executeCommand:[PXPresentGreen new]];
}

- (void)showBluePressed {
    [[LHRouter sharedInstance] executeCommand:[PXPresentBlue new]];
}

- (void)showBlueThroughGreenPressed {
    [[LHRouter sharedInstance] executeCommand:[PXPresentBlueThroughGreen new]];
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
    
    UIButton *showRed = [UIButton buttonWithType:UIButtonTypeSystem];
    [showRed setTitle:@"Show Red" forState:UIControlStateNormal];
    [self.view addSubview:showRed];
    
    [showRed sizeToFit];
    showRed.center = CGPointMake(self.view.center.x, self.view.center.y + 90);
    
    [showRed addTarget:self action:@selector(showRedPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *showGreen = [UIButton buttonWithType:UIButtonTypeSystem];
    [showGreen setTitle:@"Show Green" forState:UIControlStateNormal];
    [self.view addSubview:showGreen];
    
    [showGreen sizeToFit];
    showGreen.center = CGPointMake(self.view.center.x, self.view.center.y + 150);
    
    [showGreen addTarget:self action:@selector(showGreenPressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showBluePressed {
    [[LHRouter sharedInstance] executeCommand:[PXPresentBlue new]];
}

- (void)showRedPressed {
    [[LHRouter sharedInstance] executeCommand:[PXPresentRed new]];
}

- (void)showGreenPressed {
    [[LHRouter sharedInstance] executeCommand:[PXPresentGreenFromGreen new]];
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
