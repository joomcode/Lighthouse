//
//  RTRUpdateHandlerImpl.m
//  Router
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRUpdateHandlerImpl.h"
#import "RTRCommand.h"

@interface RTRUpdateHandlerImpl ()

@property (nonatomic, strong, readonly) NSMapTable<Class, RTRCommandHandlerBlock> *handlerBlocksByCommandClasses;
@property (nonatomic, strong, readonly) NSMapTable<id<RTRCommand>, RTRCommandHandlerBlock> *handlerBlocksByCommands;

@property (nonatomic, copy) RTRStateHandlerBlock stateHandlerBlock;

@end


@implementation RTRUpdateHandlerImpl

#pragma mark - RTRUpdateHandler

- (void)handleCommandClass:(Class)commandClass withBlock:(RTRCommandHandlerBlock)block {
    [self.handlerBlocksByCommandClasses setObject:[block copy] forKey:commandClass];
}

- (void)handleCommand:(id<RTRCommand>)command withBlock:(RTRCommandHandlerBlock)block {
    [self.handlerBlocksByCommands setObject:[block copy] forKey:command];
}

- (void)handleStateUpdatesWithBlock:(RTRStateHandlerBlock)block {
    self.stateHandlerBlock = [block copy];
}

#pragma mark - Handling

- (void)handleCommand:(id<RTRCommand>)command animated:(BOOL)animated {
    RTRCommandHandlerBlock handlerBlock = [self.handlerBlocksByCommands objectForKey:command];
    
    if (!handlerBlock) {
        handlerBlock = [self.handlerBlocksByCommandClasses objectForKey:[command class]];
    }
    
    if (handlerBlock) {
        handlerBlock(command, animated);
    }
}

- (void)handleStateUpdate:(RTRNodeState)state {
    if (self.stateHandlerBlock) {
        self.stateHandlerBlock(state);
    }
}

#pragma mark - Lazy stuff

@synthesize handlerBlocksByCommandClasses = _handlerBlocksByCommandClasses;
@synthesize handlerBlocksByCommands = _handlerBlocksByCommands;

- (NSMapTable<Class, RTRCommandHandlerBlock> *)handlerBlocksByCommandClasses {
    if (!_handlerBlocksByCommandClasses) {
        _handlerBlocksByCommands = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _handlerBlocksByCommandClasses;
}

- (NSMapTable<id<RTRCommand>, RTRCommandHandlerBlock> *)handlerBlocksByCommands {
    if (!_handlerBlocksByCommands) {
        _handlerBlocksByCommands = [NSMapTable weakToStrongObjectsMapTable];
    }
    return _handlerBlocksByCommands;
}

@end
