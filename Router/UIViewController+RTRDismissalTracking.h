//
//  UIViewController+RTRDismissalTracking.h
//  Router
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^RTRViewControllerDismissalTrackingBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (RTRDismissalTracking)

@property (nonatomic, copy) RTRViewControllerDismissalTrackingBlock rtr_onDismissalBlock;

@end
