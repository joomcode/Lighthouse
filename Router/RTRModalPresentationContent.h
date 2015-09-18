//
//  RTRModalPresentationContent.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContent.h"
#import <UIKit/UIKit.h>

@interface RTRModalPresentationContent : NSObject <RTRNodeContent>

@property (nonatomic, readonly) UIWindow *data;

- (instancetype)initWithWindow:(UIWindow *)window;

@end
