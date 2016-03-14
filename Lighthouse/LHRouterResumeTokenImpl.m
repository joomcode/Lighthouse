//
//  LHRouterResumeTokenImpl.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHRouterResumeTokenImpl.h"

@interface LHRouterResumeTokenImpl ()

@property (nonatomic, copy) void (^resumeBlock)(LHRouterResumeTokenImpl *token);

@end


@implementation LHRouterResumeTokenImpl

#pragma mark - Init

- (instancetype)initWithResumeBlock:(void (^)(LHRouterResumeTokenImpl *))block {
    self = [super init];
    if (!self) return nil;
    
    _resumeBlock = [block copy];
    
    return self;
}

#pragma mark - Dealloc

- (void)dealloc {
    [self resume];
}

#pragma mark - LHRouterResumeToken

- (void)resume {
    if (self.resumeBlock) {
        self.resumeBlock(self);
        self.resumeBlock = nil;
    }
}

@end
