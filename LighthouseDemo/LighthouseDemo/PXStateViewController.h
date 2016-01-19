//
//  PXStateViewController.h
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 03/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Lighthouse.h>

@interface PXStateViewController : UIViewController

- (instancetype)initWithUpdateHandler:(id<LHUpdateHandler>)updateHandler;

@end
