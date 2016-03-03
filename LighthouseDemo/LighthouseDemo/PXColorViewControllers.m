//
//  PXColorViewControllers.m
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "PXColorViewControllers.h"
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