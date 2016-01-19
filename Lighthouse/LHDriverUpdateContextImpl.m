//
//  LHDriverUpdateContextImpl.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriverUpdateContextImpl.h"

@interface LHDriverUpdateContextImpl ()

@property (nonatomic, copy, readonly) id<LHDriver> (^driverBlock)(id<LHNode> node);

@end


@implementation LHDriverUpdateContextImpl

#pragma mark - Init

- (instancetype)initWithAnimated:(BOOL)animated
                         command:(id<LHCommand>)command
                   childrenState:(id<LHNodeChildrenState>)childrenState
                     updateQueue:(LHTaskQueue *)updateQueue
                     driverBlock:(id<LHDriver> (^)(id<LHNode>))driverBlock {
    self = [super init];
    if (!self) return nil;
    
    _animated = animated;
    _command = command;
    _childrenState = childrenState;
    _updateQueue = updateQueue;
    _driverBlock = [driverBlock copy];
    
    return self;
}

#pragma mark - LHDriverUpdateContext

@synthesize animated = _animated;
@synthesize command = _command;
@synthesize childrenState = _childrenState;
@synthesize updateQueue = _updateQueue;

- (id<LHDriver>)driverForNode:(id<LHNode>)node {
    return self.driverBlock(node);
}

@end
