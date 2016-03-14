//
//  LHDriverUpdateContext.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 08/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHDriverUpdateContext.h"

@implementation LHDriverUpdateContext

- (instancetype)initWithAnimated:(BOOL)animated
                         command:(id<LHCommand>)command
                   childrenState:(id<LHNodeChildrenState>)childrenState
                     updateQueue:(id<LHTaskQueue>)updateQueue {
    self = [super init];
    if (!self) return nil;
    
    _animated = animated;
    _command = command;
    _childrenState = childrenState;
    _updateQueue = updateQueue;
    
    return self;
}

@end
