//
//  RTRBlockTask.h
//  Router
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRTask.h"
#import "RTRTaskQueue.h"

@interface RTRBlockTask : NSObject <RTRTask>

- (instancetype)initWithBlock:(RTRTaskQueueBlock)block;

- (instancetype)initWithAsyncBlock:(RTRTaskQueueAsyncBlock)block;

@end
