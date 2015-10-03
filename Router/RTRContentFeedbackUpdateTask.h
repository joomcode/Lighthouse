//
//  RTRContentFeedbackUpdateTask.h
//  Router
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRNodeUpdateTask.h"

@interface RTRContentFeedbackUpdateTask : RTRNodeUpdateTask

- (instancetype)initWithComponents:(RTRComponents *)components
                          animated:(BOOL)animated
                        sourceNode:(id<RTRNode>)node
                   nodeUpdateBlock:(void (^)())block;

- (void)sourceNodeContentUpdateDidFinish;

@end
