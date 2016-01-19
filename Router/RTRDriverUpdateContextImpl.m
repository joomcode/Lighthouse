//
//  RTRDriverUpdateContextImpl.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriverUpdateContextImpl.h"

@interface RTRDriverUpdateContextImpl ()

@property (nonatomic, copy, readonly) id<RTRDriver> (^driverBlock)(id<RTRNode> node);

@end


@implementation RTRDriverUpdateContextImpl

#pragma mark - Init

- (instancetype)initWithAnimated:(BOOL)animated
                         command:(id<RTRCommand>)command
                   childrenState:(id<RTRNodeChildrenState>)childrenState
                     updateQueue:(RTRTaskQueue *)updateQueue
                     driverBlock:(id<RTRDriver> (^)(id<RTRNode>))driverBlock {
    self = [super init];
    if (!self) return nil;
    
    _animated = animated;
    _command = command;
    _childrenState = childrenState;
    _updateQueue = updateQueue;
    _driverBlock = [driverBlock copy];
    
    return self;
}

#pragma mark - RTRDriverUpdateContext

@synthesize animated = _animated;
@synthesize command = _command;
@synthesize childrenState = _childrenState;
@synthesize updateQueue = _updateQueue;

- (id<RTRDriver>)driverForNode:(id<RTRNode>)node {
    return self.driverBlock(node);
}

@end
