//
//  RTRDriverFeedbackChannel.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;

NS_ASSUME_NONNULL_BEGIN


@protocol RTRDriverFeedbackChannel <NSObject>

- (void)startNodeUpdateWithBlock:(void (^)(id<RTRNode> node))updateBlock;

- (void)finishNodeUpdate;

@end


NS_ASSUME_NONNULL_END