//
//  RTRNodeContentUpdateContextImpl.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentUpdateContext.h"

@interface RTRNodeContentUpdateContextImpl : NSObject <RTRNodeContentUpdateContext>

- (instancetype)initWithAnimated:(BOOL)animated
                         command:(id<RTRCommand>)command
                     updateQueue:(RTRTaskQueue *)updateQueue
                   childrenState:(id<RTRNodeChildrenState>)childrenState
                    contentBlock:(id<RTRNodeContent> (^)(id<RTRNode> node))contentBlock;

@end
