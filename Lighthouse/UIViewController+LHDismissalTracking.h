//
//  UIViewController+LHDismissalTracking.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^LHViewControllerDismissalTrackingBlock)(UIViewController *viewController, BOOL animated);


@interface UIViewController (LHDismissalTracking)

@property (nonatomic, copy, nullable) LHViewControllerDismissalTrackingBlock lh_onDismissalBlock;

@end


NS_ASSUME_NONNULL_END