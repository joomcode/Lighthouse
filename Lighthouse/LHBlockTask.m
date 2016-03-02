//
//  LHBlockTask.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHBlockTask.h"

@interface LHBlockTask ()

@property (nonatomic, copy, readonly) LHAsyncTaskBlock block;

@end


@implementation LHBlockTask

#pragma mark - Init

- (instancetype)initWithBlock:(LHTaskBlock)block {
    return [self initWithAsyncBlock:^(LHTaskCompletionBlock completion) {
        block();
        completion();
    }];
}

- (instancetype)initWithAsyncBlock:(LHAsyncTaskBlock)block {
    self = [super init];
    if (!self) return nil;
    
    _block = [block copy];
    
    return self;
}

#pragma mark - LHTask

- (void)startWithCompletionBlock:(LHTaskCompletionBlock)completionBlock {
    self.block(completionBlock);
}

@end
