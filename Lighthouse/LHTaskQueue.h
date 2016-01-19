//
//  LHTaskQueue.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 18/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHTask.h"

NS_ASSUME_NONNULL_BEGIN


typedef void (^LHTaskQueueBlock)();
typedef void (^LHTaskQueueAsyncBlock)(LHTaskCompletionBlock completion);


@protocol LHTaskQueue <NSObject>

- (void)runTask:(id<LHTask>)task;

@end


@interface LHTaskQueue : NSObject <LHTaskQueue>

- (void)runTaskWithBlock:(LHTaskQueueBlock)block;

- (void)runAsyncTaskWithBlock:(LHTaskQueueAsyncBlock)block;

@end


NS_ASSUME_NONNULL_END