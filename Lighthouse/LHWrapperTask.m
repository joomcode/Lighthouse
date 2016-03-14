//
//  LHWrapperTask.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHWrapperTask.h"

@interface LHWrapperTask ()

@property (nonatomic, strong, readonly) id<LHTask> task;

@property (nonatomic, copy, readonly) LHTaskCompletionBlock completion;

@end


@implementation LHWrapperTask

#pragma mark - Init

- (instancetype)initWithTask:(id<LHTask>)task completion:(LHTaskCompletionBlock)completion {
    self = [super init];
    if (!self) return nil;
    
    _task = task;
    _completion = [completion copy];
    
    return self;
}

#pragma mark - LHTask

- (void)startWithCompletionBlock:(LHTaskCompletionBlock)completionBlock {
    [self.task startWithCompletionBlock:^{
        self.completion();
        completionBlock();
    }];
}

@end
