//
//  UIViewController+LHDismissalTracking.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "UIViewController+LHDismissalTracking.h"
#import <objc/runtime.h>

@implementation UIViewController (LHDismissalTracking)

#pragma mark - Swizzling

+ (void)load {
    Method existingMethod = class_getInstanceMethod(self, @selector(viewWillDisappear:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(lh_viewWillDisappear:));
    method_exchangeImplementations(existingMethod, swizzledMethod);
}

- (void)lh_viewWillDisappear:(BOOL)animated {
    [self lh_viewWillDisappear:animated];
    
    if (self.isBeingDismissed && self.lh_onDismissalBlock) {
        self.lh_onDismissalBlock(self, animated);
    }
}

#pragma mark - Block

static const char kOnDismissalBlockKey;

- (LHViewControllerDismissalTrackingBlock)lh_onDismissalBlock {
    return objc_getAssociatedObject(self, &kOnDismissalBlockKey);
}

- (void)setLh_onDismissalBlock:(LHViewControllerDismissalTrackingBlock)block {
    objc_setAssociatedObject(self, &kOnDismissalBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
