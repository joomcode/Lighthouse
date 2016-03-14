//
//  LHDriverChannelImpl.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriverChannel.h"

@class LHComponents;
@protocol LHTaskQueue;

NS_ASSUME_NONNULL_BEGIN


@interface LHDriverChannelImpl : NSObject <LHDriverChannel>

- (instancetype)initWithNode:(id<LHNode>)node
                  components:(LHComponents *)components
                 updateQueue:(id<LHTaskQueue>)updateQueue NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END