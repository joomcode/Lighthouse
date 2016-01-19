//
//  RTRBlockTask.h
//  Router
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRTask.h"
#import "RTRTaskQueue.h"

NS_ASSUME_NONNULL_BEGIN


@interface RTRBlockTask : NSObject <RTRTask>

- (instancetype)initWithBlock:(RTRTaskQueueBlock)block;

- (instancetype)initWithAsyncBlock:(RTRTaskQueueAsyncBlock)block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END