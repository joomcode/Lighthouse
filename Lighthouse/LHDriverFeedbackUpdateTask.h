//
//  LHDriverFeedbackUpdateTask.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHNodeUpdateTask.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHDriverFeedbackUpdateTask : LHNodeUpdateTask

- (instancetype)initWithComponents:(LHComponents *)components
                          animated:(BOOL)animated
                        sourceNode:(id<LHNode>)node
                   nodeUpdateBlock:(void (^)(void))block NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithComponents:(LHComponents *)components animated:(BOOL)animated NS_UNAVAILABLE;

- (void)sourceDriverUpdateDidFinish;

@end


NS_ASSUME_NONNULL_END
