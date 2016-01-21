//
//  LHUpdateBusImpl.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 20/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHUpdateBusImpl.h"
#import "LHCommand.h"

@interface LHUpdateBusImpl ()

@property (nonatomic, strong, readonly) NSMutableArray<LHSingleShotCommandHandlerBlock> *commandHandlerBlocks;
@property (nonatomic, strong, readonly) NSMutableArray<LHPresentationStateHandlerBlock> *stateHandlerBlocks;

@end


@implementation LHUpdateBusImpl

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _commandHandlerBlocks = [[NSMutableArray alloc] init];
    _stateHandlerBlocks = [[NSMutableArray alloc] init];
    
    return self;
}

#pragma mark - LHUpdateBus

- (void)addCommandHandler:(LHCommandHandlerBlock)handlerBlock {
    [self addSingleShotCommandHandler:^BOOL(id<LHCommand> command, BOOL animated) {
        handlerBlock(command, animated);
        return NO;
    }];
}

- (void)addSingleShotCommandHandler:(LHSingleShotCommandHandlerBlock)handlerBlock {
    [self.commandHandlerBlocks addObject:[handlerBlock copy]];
}

- (void)addCommandClass:(Class)commandClass handler:(LHCommandHandlerBlock)handlerBlock {
    [self addCommandHandler:^(id<LHCommand> command, BOOL animated) {
        if ([command isKindOfClass:commandClass]) {
            handlerBlock(command, animated);
        }
    }];
}

- (void)addPresentationStateUpdateHandler:(LHPresentationStateHandlerBlock)handlerBlock {
    [self.stateHandlerBlocks addObject:[handlerBlock copy]];
}

#pragma mark - Handling

- (void)handleCommand:(id<LHCommand>)command animated:(BOOL)animated {
    __block NSMutableIndexSet *blocksToRemove = nil;
    
    [self.commandHandlerBlocks enumerateObjectsUsingBlock:^(LHSingleShotCommandHandlerBlock block, NSUInteger idx, BOOL *stop) {
        BOOL shouldRemove = block(command, animated);
        
        if (shouldRemove) {
            if (!blocksToRemove) {
                blocksToRemove = [[NSMutableIndexSet alloc] init];
            }
            [blocksToRemove addIndex:idx];
        }
    }];
    
    if (blocksToRemove) {
        [self.commandHandlerBlocks removeObjectsAtIndexes:blocksToRemove];
    }
}

- (void)handlePresentationStateUpdate:(LHNodePresentationState)presentationState {
    for (LHPresentationStateHandlerBlock block in self.stateHandlerBlocks) {
        block(presentationState);
    }
}

@end
