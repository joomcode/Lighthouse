//
//  LHDriverUpdateContextImpl.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriverUpdateContext.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHDriverUpdateContextImpl : NSObject <LHDriverUpdateContext>

- (instancetype)initWithAnimated:(BOOL)animated
                         command:(nullable id<LHCommand>)command
                   childrenState:(nullable id<LHNodeChildrenState>)childrenState
                     updateQueue:(LHTaskQueue *)updateQueue
                     driverBlock:(id<LHDriver> (^)(id<LHNode> node))driverBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END