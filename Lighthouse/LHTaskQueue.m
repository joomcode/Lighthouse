//
//  LHTaskQueue.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHTaskQueue.h"
#import "LHBlockTask.h"

@interface LHTaskQueue ()

@property (nonatomic, strong) NSMutableArray<id<LHTask>> *tasks;

@property (nonatomic, assign) BOOL taskInProgress;

@end


@implementation LHTaskQueue

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _tasks = [[NSMutableArray alloc] init];
    
    return self;
}

#pragma mark - LHTaskQueue

- (void)runTask:(id<LHTask>)task {
    [self.tasks addObject:task];
    
    if (!self.taskInProgress) {
        [self doRunTask:task];
    }
}

- (void)runTaskWithBlock:(LHTaskBlock)block {
    [self runTask:[[LHBlockTask alloc] initWithBlock:block]];
}

- (void)runAsyncTaskWithBlock:(LHAsyncTaskBlock)block {
    [self runTask:[[LHBlockTask alloc] initWithAsyncBlock:block]];
}

#pragma mark - Private

- (void)doRunTask:(id<LHTask>)task {
    self.taskInProgress = YES;
    
    [task startWithCompletionBlock:^{
        [self.tasks removeObject:task];
        
        self.taskInProgress = NO;
        
        [self runNextTaskIfPossible];
    }];
}

- (void)runNextTaskIfPossible {
    if (self.taskInProgress || self.tasks.count == 0) {
        return;
    }
    
    [self doRunTask:self.tasks[0]];
}

@end
