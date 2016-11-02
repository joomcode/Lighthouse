//
//  LHRouter+Shared.m
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHRouter+Shared.h"
#import "AppDelegate.h"

@implementation LHRouter (Shared)

+ (instancetype)sharedInstance {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.router;
}

@end
