//
//  LHRouter+Shared.m
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHRouter+Shared.h"

@implementation LHRouter (Shared)

+ (instancetype)sharedInstance {
    static LHRouter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

@end
