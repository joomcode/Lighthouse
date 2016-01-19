//
//  RTRTaskQueue.m
//  Router
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRTaskQueue.h"
#import "RTRBlockTask.h"

@interface RTRTaskQueue ()

@property (nonatomic, strong) NSMutableArray<id<RTRTask>> *tasks;

@property (nonatomic, assign) BOOL taskInProgress;

@end


@implementation RTRTaskQueue

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _tasks = [[NSMutableArray alloc] init];
    
    return self;
}

#pragma mark - RTRTaskQueue

- (void)runTask:(id<RTRTask>)task {
    [self.tasks addObject:task];
    
    if (!self.taskInProgress) {
        [self doRunTask:task];
    }
}

- (void)runTaskWithBlock:(RTRTaskQueueBlock)block {
    [self runTask:[[RTRBlockTask alloc] initWithBlock:block]];
}

- (void)runAsyncTaskWithBlock:(RTRTaskQueueAsyncBlock)block {
    [self runTask:[[RTRBlockTask alloc] initWithAsyncBlock:block]];
}

#pragma mark - Private

- (void)doRunTask:(id<RTRTask>)task {
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
