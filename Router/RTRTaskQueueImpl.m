//
//  RTRTaskQueueImpl.m
//  Router
//
//  Created by Nick Tymchenko on 18/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRTaskQueueImpl.h"

@interface RTRTaskQueueImpl ()

@property (nonatomic, strong) NSMutableArray *asyncBlocks;

@property (nonatomic, assign) BOOL inProgress;

@end


@implementation RTRTaskQueueImpl

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _asyncBlocks = [[NSMutableArray alloc] init];
    
    return self;
}

#pragma mark - RTRTaskQueue

- (void)runTaskWithBlock:(RTRTaskQueueBlock)block {
    if (!self.inProgress) {
        block();
        return;
    }
    
    [self runAsyncTaskWithBlock:^(RTRTaskQueueAsyncCompletionBlock completion) {
        block();
        completion();
    }];
}

- (void)runAsyncTaskWithBlock:(RTRTaskQueueAsyncBlock)block {
    [self.asyncBlocks addObject:block];
    
    [self dequeueBlockIfPossible];
}

#pragma mark - Private

- (void)dequeueBlockIfPossible {
    if (self.inProgress || self.asyncBlocks.count == 0) {
        return;
    }
    
    self.inProgress = YES;
    
    RTRTaskQueueAsyncBlock block = self.asyncBlocks[0];
    [self.asyncBlocks removeObjectAtIndex:0];
    
    block(^{
        self.inProgress = NO;
        
        [self dequeueBlockIfPossible];
    });
}

@end
