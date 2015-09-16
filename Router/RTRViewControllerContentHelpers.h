//
//  RTRViewControllerContentHelpers.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNodeContentUpdateContext;

@interface RTRViewControllerContentHelpers : NSObject

+ (NSArray *)childViewControllersWithUpdateContext:(id<RTRNodeContentUpdateContext>)updateContext;

@end
