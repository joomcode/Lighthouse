//
//  RTRTaskQueue.h
//  Router
//
//  Created by Nick Tymchenko on 18/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTRTask.h"

typedef void (^RTRTaskQueueBlock)();
typedef void (^RTRTaskQueueAsyncBlock)(RTRTaskCompletionBlock completion);


@protocol RTRTaskQueue <NSObject>

- (void)runTask:(id<RTRTask>)task;

@end


@interface RTRTaskQueue : NSObject <RTRTaskQueue>

- (void)runTaskWithBlock:(RTRTaskQueueBlock)block;

- (void)runAsyncTaskWithBlock:(RTRTaskQueueAsyncBlock)block;

@end