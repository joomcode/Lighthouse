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
@property (nonatomic, strong, readonly) NSMapTable<Class, LHDriverDataUpdateBlock> *dataUpdateBlocksByCommandClass;

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
    _dataUpdateBlocksByCommandClass = [NSMapTable strongToStrongObjectsMapTable];
    
    _updateBus = [[LHUpdateBusImpl alloc] init];
    
    return self;
}

#pragma mark - Setup

- (void)bindCommandClass:(Class)commandClass toDataInitBlock:(LHDriverDataInitBlock)block {
    [self.dataInitBlocksByCommandClass setObject:[block copy] forKey:commandClass];
}

- (void)bindCommandClass:(Class)commandClass toDataUpdateBlock:(LHDriverDataUpdateBlock)block {
    [self.dataUpdateBlocksByCommandClass setObject:[block copy] forKey:commandClass];
}

#pragma mark - LHDriver

@synthesize data = _data;

- (void)updateWithContext:(LHDriverUpdateContext *)context {
    id<LHCommand> command = context.command;
    
    id oldData = _data;
    
    if (!_data) {
        LHDriverDataInitBlock block = [self.dataInitBlocksByCommandClass objectForKey:[command class]];
        
        if (!block) {
            block = self.defaultDataInitBlock;
        }
        
        if (block) {
            _data = block(command, self.updateBus);
        }
        
        if (!_data) {
            [NSException raise:NSInternalInconsistencyException format:@"LHUpdateHandlerDriver couldn't create data for command %@. Consider using defaultDataInitBlock?", command];
        }
    } else {
        LHDriverDataUpdateBlock block = [self.dataUpdateBlocksByCommandClass objectForKey:[command class]];
        
        if (block) {
            _data = block(_data, command, self.updateBus);
        }
    }
    
    if (oldData != _data) {
        // Inject updateBus into the newly created data if it conforms to <LHUpdateHandler>.
        
        if ([_data conformsToProtocol:@protocol(LHUpdateHandler)]) {
            [(id<LHUpdateHandler>)_data awakeForLighthouseUpdateHandlingWithUpdateBus:self.updateBus];
        }
    }
    
    [self.updateBus handleCommand:command animated:context.animated];
}

- (void)stateDidChange:(LHNodeState)state {
    [self.updateBus handleStateUpdate:state];
}

@end
