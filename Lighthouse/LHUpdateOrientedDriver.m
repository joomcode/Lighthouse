//
//  LHUpdateOrientedDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHUpdateOrientedDriver.h"
#import "LHCommand.h"
#import "LHDriverUpdateContext.h"
#import "LHUpdateHandlerImpl.h"

@interface LHUpdateOrientedDriver ()

@property (nonatomic, strong, readonly) NSMapTable<Class, LHDriverDataInitBlock> *dataInitBlocksByCommandClass;

@property (nonatomic, strong, readonly) LHUpdateHandlerImpl *updateHandler;

@end


@implementation LHUpdateOrientedDriver

#pragma mark - Setup

- (void)bindCommandClass:(Class)commandClass toDataInitBlock:(LHDriverDataInitBlock)block {
    [self.dataInitBlocksByCommandClass setObject:[block copy] forKey:commandClass];
}

#pragma mark - LHDriver

@synthesize data = _data;

- (void)updateWithContext:(id<LHDriverUpdateContext>)context {
    id<LHCommand> command = context.command;
    
    if (!_data) {
        LHDriverDataInitBlock block = [self.dataInitBlocksByCommandClass objectForKey:[command class]];
        
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

- (void)stateDidChange:(LHNodeState)state {
    [self.updateHandler handleStateUpdate:state];
}

#pragma mark - Lazy stuff

@synthesize dataInitBlocksByCommandClass = _dataInitBlocksByCommandClass;
@synthesize updateHandler = _updateHandler;

- (NSMapTable<Class, LHDriverDataInitBlock> *)dataInitBlocksByCommandClass {
    if (!_dataInitBlocksByCommandClass) {
        _dataInitBlocksByCommandClass = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _dataInitBlocksByCommandClass;
}

- (LHUpdateHandlerImpl *)updateHandler {
    if (!_updateHandler) {
        _updateHandler = [[LHUpdateHandlerImpl alloc] init];
    }
    return _updateHandler;
}

@end
