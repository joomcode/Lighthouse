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


@protocol LHDriverChannel <NSObject>

- (void)startNodeUpdateWithBlock:(void (^)(id<LHNode> node))updateBlock;

- (void)finishNodeUpdate;

@end


NS_ASSUME_NONNULL_END