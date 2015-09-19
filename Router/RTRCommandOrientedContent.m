//
//  RTRCommandOrientedContent.m
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRCommandOrientedContent.h"
#import "RTRCommand.h"
#import "RTRNodeContentUpdateContext.h"
#import "RTRCommandHandlerImpl.h"

@interface RTRCommandOrientedContent ()

@property (nonatomic, readonly) NSMapTable *dataInitBlocksByCommandClass;

@property (nonatomic, readonly) RTRCommandHandlerImpl *commandHandler;

@end


@implementation RTRCommandOrientedContent

#pragma mark - Setup

- (void)bindCommandClass:(Class)commandClass toDataInitBlock:(RTRNodeContentDataInitBlock)block {
    [self.dataInitBlocksByCommandClass setObject:[block copy] forKey:commandClass];
}

#pragma mark - RTRNodeContent

@synthesize data = _data;

- (void)updateWithContext:(id<RTRNodeContentUpdateContext>)updateContext {
    id<RTRCommand> command = updateContext.command;
    
    if (!_data) {
        RTRNodeContentDataInitBlock block = [self.dataInitBlocksByCommandClass objectForKey:[command class]];
        
        if (!block) {
            block = self.defaultDataInitBlock;
        }
        
        if (block) {
            _data = block(command, self.commandHandler);
        }
        
        NSAssert(_data != nil, @""); // TODO
    } else {
        [self.commandHandler handleCommand:command animated:updateContext.animated];
    }
}

#pragma mark - Lazy stuff

@synthesize dataInitBlocksByCommandClass = _dataInitBlocksByCommandClass;
@synthesize commandHandler = _commandHandler;

- (NSMapTable *)dataInitBlocksByCommandClass {
    if (!_dataInitBlocksByCommandClass) {
        _dataInitBlocksByCommandClass = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _dataInitBlocksByCommandClass;
}

- (RTRCommandHandlerImpl *)commandHandler {
    if (!_commandHandler) {
        _commandHandler = [[RTRCommandHandlerImpl alloc] init];
    }
    return _commandHandler;
}

@end
