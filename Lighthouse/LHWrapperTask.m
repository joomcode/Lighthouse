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
@property (nonatomic, copy, readonly) LHTaskBlock willStartBlock;
@property (nonatomic, copy, readonly) LHTaskBlock didFinishBlock;

@end


@implementation LHWrapperTask

#pragma mark - Init

- (instancetype)initWithTask:(id<LHTask>)task
              willStartBlock:(LHTaskBlock)willStartBlock
              didFinishBlock:(LHTaskBlock)didFinishBlock {
    self = [super init];
    if (!self) return nil;
    
    _task = task;
    _willStartBlock = [willStartBlock copy];
    _didFinishBlock = [didFinishBlock copy];
    
    return self;
}

#pragma mark - LHTask

- (void)startWithCompletionBlock:(LHTaskCompletionBlock)completionBlock {
    if (self.willStartBlock) {
        self.willStartBlock();
    }
    
    [self.task startWithCompletionBlock:^{
        if (self.didFinishBlock) {
            self.didFinishBlock();
        }
        
        completionBlock();
    }];
}

@end
