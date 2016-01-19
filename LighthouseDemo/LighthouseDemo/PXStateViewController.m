//
//  PXStateViewController.m
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 03/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "PXStateViewController.h"

@interface PXStateViewController ()

@property (nonatomic, strong) UILabel *stateLabel;

@end


@implementation PXStateViewController

- (instancetype)initWithUpdateHandler:(id<LHUpdateHandler>)updateHandler {
    self = [super init];
    if (!self) return nil;
    
    [updateHandler handleStateUpdatesWithBlock:^(LHNodeState state) {
        self.stateLabel.text = LHStringFromNodeState(state);
    }];
    
    return self;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
    }
    return _stateLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.stateLabel];
    
    self.stateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.stateLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.stateLabel
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
}

@end
