//
//  RTRDriverUpdateContextImpl.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriverUpdateContext.h"

NS_ASSUME_NONNULL_BEGIN


@interface RTRDriverUpdateContextImpl : NSObject <RTRDriverUpdateContext>

- (instancetype)initWithAnimated:(BOOL)animated
                         command:(nullable id<RTRCommand>)command
                   childrenState:(nullable id<RTRNodeChildrenState>)childrenState
                     updateQueue:(RTRTaskQueue *)updateQueue
                     driverBlock:(id<RTRDriver> (^)(id<RTRNode> node))driverBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END