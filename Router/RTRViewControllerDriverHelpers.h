//
//  RTRViewControllerDriverHelpers.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRDriverUpdateContext;

@interface RTRViewControllerDriverHelpers : NSObject

+ (NSArray *)childViewControllersWithUpdateContext:(id<RTRDriverUpdateContext>)updateContext;

@end
