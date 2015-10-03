//
//  PXStateDisplayingViewController.h
//  RouterDemo
//
//  Created by Nick Tymchenko on 03/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Router.h>

@interface PXStateDisplayingViewController : UIViewController

- (instancetype)initWithUpdateHandler:(id<RTRUpdateHandler>)updateHandler;

@end
