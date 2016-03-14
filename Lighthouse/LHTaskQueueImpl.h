//
//  LHTaskQueueImpl.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHTaskQueue.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHTaskQueueImpl : NSObject <LHTaskQueue>

@property (nonatomic, assign, getter = isSuspended) BOOL suspended;

@end


NS_ASSUME_NONNULL_END