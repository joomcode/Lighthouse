//
//  LHBlockTask.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHTask.h"
#import "LHTaskBlocks.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHBlockTask : NSObject <LHTask>

- (instancetype)initWithBlock:(LHTaskBlock)block;

- (instancetype)initWithAsyncBlock:(LHAsyncTaskBlock)block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END