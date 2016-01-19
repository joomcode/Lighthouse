//
//  RTRUpdateOrientedDriver.m
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRUpdateOrientedDriver.h"
#import "RTRCommand.h"
#import "RTRDriverUpdateContext.h"
#import "RTRUpdateHandlerImpl.h"

@interface RTRUpdateOrientedDriver ()

@property (nonatomic, strong, readonly) NSMapTable<Class, RTRDriverDataInitBlock> *dataInitBlocksByCommandClass;

@property (nonatomic, strong, readonly) RTRUpdateHandlerImpl *updateHandler;

@end


@implementation RTRUpdateOrientedDriver

#pragma mark - Setup

- (void)bindCommandClass:(Class)commandClass toDataInitBlock:(RTRDriverDataInitBlock)block {
    [self.dataInitBlocksByCommandClass setObject:[block copy] forKey:commandClass];
}

#pragma mark - RTRDriver

@synthesize data = _data;

- (void)updateWithContext:(id<RTRDriverUpdateContext>)context {
    id<RTRCommand> command = context.command;
    
    if (!_data) {
        RTRDriverDataInitBlock block = [self.dataInitBlocksByCommandClass objectForKey:[command class]];
        
        if (!block) {
            block = self.defaultDataInitBlock;
        }
        
        if (block) {
            _data = block(command, self.updateHandler);
        }
        
        NSAssert(_data != nil, @""); // TODO
    } else {
        [self.updateHandler handleCommand:command animated:context.animated];
    }
}

- (void)stateDidChange:(RTRNodeState)state {
    [self.updateHandler handleStateUpdate:state];
}

#pragma mark - Lazy stuff

@synthesize dataInitBlocksByCommandClass = _dataInitBlocksByCommandClass;
@synthesize updateHandler = _updateHandler;

- (NSMapTable<Class, RTRDriverDataInitBlock> *)dataInitBlocksByCommandClass {
    if (!_dataInitBlocksByCommandClass) {
        _dataInitBlocksByCommandClass = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _dataInitBlocksByCommandClass;
}

- (RTRUpdateHandlerImpl *)updateHandler {
    if (!_updateHandler) {
        _updateHandler = [[RTRUpdateHandlerImpl alloc] init];
    }
    return _updateHandler;
}

@end
