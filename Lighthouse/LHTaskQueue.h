//
//  LHTaskQueue.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 18/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHTaskBlocks.h"

@protocol LHTask;

NS_ASSUME_NONNULL_BEGIN


@protocol LHTaskQueue <NSObject>

- (void)runTask:(id<LHTask>)task;

@end


@interface LHTaskQueue : NSObject <LHTaskQueue>

- (void)runTaskWithBlock:(LHTaskBlock)block;

- (void)runAsyncTaskWithBlock:(LHAsyncTaskBlock)block;

@end


NS_ASSUME_NONNULL_END