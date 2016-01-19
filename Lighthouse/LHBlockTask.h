//
//  LHBlockTask.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHTask.h"
#import "LHTaskQueue.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHBlockTask : NSObject <LHTask>

- (instancetype)initWithBlock:(LHTaskQueueBlock)block;

- (instancetype)initWithAsyncBlock:(LHTaskQueueAsyncBlock)block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END