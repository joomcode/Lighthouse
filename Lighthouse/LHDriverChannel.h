//
//  LHDriverChannel.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN

typedef void(^LHDriverChannelUpdateBlock)(id<LHNode> node);

@protocol LHDriverChannel <NSObject>

- (void)startNodeUpdateWithBlock:(LHDriverChannelUpdateBlock)updateBlock;

- (void)startUrgentNodeUpdateWithBlock:(LHDriverChannelUpdateBlock)updateBlock;

- (void)finishNodeUpdate;

@end


NS_ASSUME_NONNULL_END