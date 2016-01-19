//
//  RTRBlockTask.m
//  Router
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRBlockTask.h"

@interface RTRBlockTask ()

@property (nonatomic, copy, readonly) RTRTaskQueueAsyncBlock block;

@end


@implementation RTRBlockTask

#pragma mark - Init

- (instancetype)initWithBlock:(RTRTaskQueueBlock)block {
    return [self initWithAsyncBlock:^(RTRTaskCompletionBlock completion) {
        block();
        completion();
    }];
}

- (instancetype)initWithAsyncBlock:(RTRTaskQueueAsyncBlock)block {
    self = [super init];
    if (!self) return nil;
    
    _block = [block copy];
    
    return self;
}

#pragma mark - RTRTask

- (void)startWithCompletionBlock:(RTRTaskCompletionBlock)completionBlock {
    self.block(completionBlock);
}

@end
