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

- (instancetype)init {
    return [self initWithAnimated:NO command:nil updateQueue:nil childrenState:nil driverBlock:nil];
}

- (instancetype)initWithAnimated:(BOOL)animated
                         command:(id<RTRCommand>)command
                     updateQueue:(RTRTaskQueue *)updateQueue
                   childrenState:(id<RTRNodeChildrenState>)childrenState
                     driverBlock:(id<RTRDriver> (^)(id<RTRNode>))driverBlock
{
    NSParameterAssert(updateQueue != nil);
    NSParameterAssert(driverBlock != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _animated = animated;
    _command = command;
    _updateQueue = updateQueue;
    _childrenState = childrenState;
    _driverBlock = [driverBlock copy];
    
    return self;
}

#pragma mark - RTRDriverUpdateContext

@synthesize animated = _animated;
@synthesize command = _command;
@synthesize updateQueue = _updateQueue;
@synthesize childrenState = _childrenState;

- (id<RTRDriver>)driverForNode:(id<RTRNode>)node {
    return self.driverBlock(node);
}

@end
