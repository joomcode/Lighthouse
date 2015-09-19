//
//  RTRCommandHandlerImpl.m
//  Router
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRCommandHandlerImpl.h"
#import "RTRCommand.h"

@interface RTRCommandHandlerImpl ()

@property (nonatomic, readonly) NSMapTable *handlerBlocksByCommandClasses;
@property (nonatomic, readonly) NSMapTable *handlerBlocksByCommands;

@end


@implementation RTRCommandHandlerImpl

#pragma mark - RTRCommandHandler

- (void)handleCommandClass:(Class)commandClass withBlock:(RTRCommandHandlerBlock)block {
    [self.handlerBlocksByCommandClasses setObject:[block copy] forKey:commandClass];
}

- (void)handleCommand:(id<RTRCommand>)command withBlock:(RTRCommandHandlerBlock)block {
    [self.handlerBlocksByCommandClasses setObject:[block copy] forKey:command];
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

#pragma mark - Lazy stuff

@synthesize handlerBlocksByCommandClasses = _handlerBlocksByCommandClasses;
@synthesize handlerBlocksByCommands = _handlerBlocksByCommands;

- (NSMapTable *)handlerBlocksByCommandClasses {
    if (!_handlerBlocksByCommandClasses) {
        _handlerBlocksByCommands = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _handlerBlocksByCommandClasses;
}

- (NSMapTable *)handlerBlocksByCommands {
    if (!_handlerBlocksByCommands) {
        _handlerBlocksByCommands = [NSMapTable weakToStrongObjectsMapTable];
    }
    return _handlerBlocksByCommands;
}

@end
