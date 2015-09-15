//
//  RTRRouter+Shared.m
//  RouterDemo
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRRouter+Shared.h"

@implementation RTRRouter (Shared)

+ (instancetype)sharedInstance {
    static RTRRouter *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

@end
