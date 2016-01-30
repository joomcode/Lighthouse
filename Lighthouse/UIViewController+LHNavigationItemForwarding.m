//
//  UIViewController+LHNavigationItemForwarding.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 30/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "UIViewController+LHNavigationItemForwarding.h"
#import <objc/runtime.h>

@implementation UIViewController (LHNavigationItemForwarding)

#pragma mark - Swizzling

+ (void)load {
    Method existingMethod = class_getInstanceMethod(self, @selector(navigationItem));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(lh_navigationItem));
    method_exchangeImplementations(existingMethod, swizzledMethod);
}

- (UINavigationItem *)lh_navigationItem {
    if (self.lh_childViewControllerForNavigationItem) {
        return self.lh_childViewControllerForNavigationItem.navigationItem;
    } else {
        return [self lh_navigationItem];
    }
}

#pragma mark - Child view controller

static const char kChildViewControllerKey;

- (UIViewController *)lh_childViewControllerForNavigationItem {
    return objc_getAssociatedObject(self, &kChildViewControllerKey);
}

- (void)setLh_childViewControllerForNavigationItem:(UIViewController *)childViewController {
    if (objc_getAssociatedObject(self, &kChildViewControllerKey) == childViewController) {
        return;
    }
    
    objc_setAssociatedObject(self, &kChildViewControllerKey, childViewController, OBJC_ASSOCIATION_ASSIGN);
    
    if (self.navigationController && !self.navigationController.navigationBarHidden) {
        // Force navigation controller to requery a navigation item. It's somewhat tricky, but it kind of makes sense :p
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationBarHidden = NO;
    }
}

@end
