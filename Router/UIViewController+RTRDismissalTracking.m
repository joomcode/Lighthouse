//
//  UIViewController+RTRDismissalTracking.m
//  Router
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "UIViewController+RTRDismissalTracking.h"
#import <objc/runtime.h>

@implementation UIViewController (RTRDismissalTracking)

#pragma mark - Swizzling

+ (void)load {
    Method existingMethod = class_getInstanceMethod(self, @selector(viewWillDisappear:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(rtr_viewWillDisappear:));
    method_exchangeImplementations(existingMethod, swizzledMethod);
}

- (void)rtr_viewWillDisappear:(BOOL)animated {
    [self rtr_viewWillDisappear:animated];
    
    if (self.isBeingDismissed && self.rtr_onDismissalBlock) {
        self.rtr_onDismissalBlock(self, animated);
    }
}

#pragma mark - Block

static const char kOnDismissalBlockKey;

- (RTRViewControllerDismissalTrackingBlock)rtr_onDismissalBlock {
    return objc_getAssociatedObject(self, &kOnDismissalBlockKey);
}

- (void)setRtr_onDismissalBlock:(RTRViewControllerDismissalTrackingBlock)block {
    objc_setAssociatedObject(self, &kOnDismissalBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
