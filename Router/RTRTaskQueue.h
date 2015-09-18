//
//  RTRTaskQueue.h
//  Router
//
//  Created by Nick Tymchenko on 18/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RTRTaskQueueBlock)();

typedef void (^RTRTaskQueueAsyncCompletionBlock)();
typedef void (^RTRTaskQueueAsyncBlock)(RTRTaskQueueAsyncCompletionBlock completion);

@protocol RTRTaskQueue <NSObject>

- (void)runTaskWithBlock:(RTRTaskQueueBlock)block;

- (void)runAsyncTaskWithBlock:(RTRTaskQueueAsyncBlock)block;

@end
