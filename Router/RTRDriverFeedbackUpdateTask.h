//
//  RTRDriverFeedbackUpdateTask.h
//  Router
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRNodeUpdateTask.h"

NS_ASSUME_NONNULL_BEGIN


@interface RTRDriverFeedbackUpdateTask : RTRNodeUpdateTask

- (instancetype)initWithComponents:(RTRComponents *)components
                          animated:(BOOL)animated
                        sourceNode:(id<RTRNode>)node
                   nodeUpdateBlock:(void (^)())block NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated NS_UNAVAILABLE;

- (void)sourceDriverUpdateDidFinish;

@end


NS_ASSUME_NONNULL_END