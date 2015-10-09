//
//  RTRDriverUpdateContextImpl.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriverUpdateContext.h"

@interface RTRDriverUpdateContextImpl : NSObject <RTRDriverUpdateContext>

- (instancetype)initWithAnimated:(BOOL)animated
                         command:(id<RTRCommand>)command
                     updateQueue:(RTRTaskQueue *)updateQueue
                   childrenState:(id<RTRNodeChildrenState>)childrenState
                     driverBlock:(id<RTRDriver> (^)(id<RTRNode> node))driverBlock;

@end
