//
//  LHUpdateHandlerImpl.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHUpdateHandlerImpl.h"
#import "LHCommand.h"

@interface LHUpdateHandlerImpl ()

@property (nonatomic, strong, readonly) NSMapTable<Class, LHCommandHandlerBlock> *handlerBlocksByCommandClasses;
@property (nonatomic, strong, readonly) NSMapTable<id<LHCommand>, LHCommandHandlerBlock> *handlerBlocksByCommands;

@property (nonatomic, copy) LHStateHandlerBlock stateHandlerBlock;

@end


@implementation LHUpdateHandlerImpl

#pragma mark - LHUpdateHandler

- (void)handleCommandClass:(Class)commandClass withBlock:(LHCommandHandlerBlock)block {
    [self.handlerBlocksByCommandClasses setObject:[block copy] forKey:commandClass];
}

- (void)handleCommand:(id<LHCommand>)command withBlock:(LHCommandHandlerBlock)block {
    [self.handlerBlocksByCommands setObject:[block copy] forKey:command];
}

- (void)handleStateUpdatesWithBlock:(LHStateHandlerBlock)block {
    self.stateHandlerBlock = [block copy];
}

#pragma mark - Handling

- (void)handleCommand:(id<LHCommand>)command animated:(BOOL)animated {
    LHCommandHandlerBlock handlerBlock = [self.handlerBlocksByCommands objectForKey:command];
    
    if (!handlerBlock) {
        handlerBlock = [self.handlerBlocksByCommandClasses objectForKey:[command class]];
    }
    
    if (handlerBlock) {
        handlerBlock(command, animated);
    }
}

- (void)handleStateUpdate:(LHNodeState)state {
    if (self.stateHandlerBlock) {
        self.stateHandlerBlock(state);
    }
}

#pragma mark - Lazy stuff

@synthesize handlerBlocksByCommandClasses = _handlerBlocksByCommandClasses;
@synthesize handlerBlocksByCommands = _handlerBlocksByCommands;

- (NSMapTable<Class, LHCommandHandlerBlock> *)handlerBlocksByCommandClasses {
    if (!_handlerBlocksByCommandClasses) {
        _handlerBlocksByCommands = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _handlerBlocksByCommandClasses;
}

- (NSMapTable<id<LHCommand>, LHCommandHandlerBlock> *)handlerBlocksByCommands {
    if (!_handlerBlocksByCommands) {
        _handlerBlocksByCommands = [NSMapTable weakToStrongObjectsMapTable];
    }
    return _handlerBlocksByCommands;
}

@end
