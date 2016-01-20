//
//  LHUpdateHandlerDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHUpdateHandlerDriver.h"
#import "LHCommand.h"
#import "LHDriverUpdateContext.h"
#import "LHUpdateBusImpl.h"
#import "LHUpdateHandler.h"

@interface LHUpdateHandlerDriver ()

@property (nonatomic, strong, readonly) NSMapTable<Class, LHDriverDataInitBlock> *dataInitBlocksByCommandClass;

@property (nonatomic, strong, readonly) LHUpdateBusImpl *updateBus;

@end


@implementation LHUpdateHandlerDriver

#pragma mark - Init

- (instancetype)init {
    return [self initWithDefaultDataInitBlock:nil];
}

- (instancetype)initWithDefaultDataInitBlock:(LHDriverDataInitBlock)block {
    self = [super init];
    if (!self) return nil;
    
    _defaultDataInitBlock = [block copy];
    
    _dataInitBlocksByCommandClass = [NSMapTable strongToStrongObjectsMapTable];
    _updateBus = [[LHUpdateBusImpl alloc] init];
    
    return self;
}

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
            _data = block(command, self.updateBus);
        }
        
        NSAssert(_data != nil, @""); // TODO
        
        if ([_data conformsToProtocol:@protocol(LHUpdateHandler)]) {
            [(id<LHUpdateHandler>)_data awakeForLighthouseUpdateHandlingWithUpdateBus:self.updateBus];
        }
    } else {
        [self.updateBus handleCommand:command animated:context.animated];
    }
}

- (void)stateDidChange:(LHNodePresentationState)state {
    [self.updateBus handleStateUpdate:state];
}

@end
