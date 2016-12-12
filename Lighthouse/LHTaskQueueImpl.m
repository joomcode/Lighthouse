//
//  LHTaskQueueImpl.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHTaskQueueImpl.h"
#import "LHBlockTask.h"

@interface LHTaskQueueImpl ()

@property (nonatomic, strong) NSMutableArray<id<LHTask>> *tasks;

@property (nonatomic, assign) BOOL taskInProgress;

@property (nonatomic, assign, getter = isBusy) BOOL busy;

@end


@implementation LHTaskQueueImpl

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
    
    [self runNextTaskIfPossible];
}

- (void)runTaskWithBlock:(LHTaskBlock)block {
    [self runTask:[[LHBlockTask alloc] initWithBlock:block]];
}

- (void)runAsyncTaskWithBlock:(LHAsyncTaskBlock)block {
    [self runTask:[[LHBlockTask alloc] initWithAsyncBlock:block]];
}

#pragma mark - Public

- (void)setSuspended:(BOOL)suspended {
    if (_suspended != suspended) {
        _suspended = suspended;
        
        [self runNextTaskIfPossible];
    }
}

#pragma mark - Private

- (void)runNextTaskIfPossible {
    if (!self.suspended && !self.taskInProgress && self.tasks.count > 0) {
        self.busy = YES;
        [self doRunTask:self.tasks[0]];
    } else {
        if (self.busy && !self.taskInProgress) {
            self.busy = NO;
        }
    }
}

- (void)doRunTask:(id<LHTask>)task {
    self.taskInProgress = YES;

    __weak typeof(task) wTask = task;
    [task startWithCompletionBlock:^{
        [self.tasks removeObject:wTask];
        self.taskInProgress = NO;
        
        [self runNextTaskIfPossible];
    }];
}

@end