//
//  UIViewController+LHNavigationItemForwarding.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 30/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIViewController (LHNavigationItemForwarding)

@property (nonatomic, weak, nullable) UIViewController *lh_childViewControllerForNavigationItem;

@end


NS_ASSUME_NONNULL_END