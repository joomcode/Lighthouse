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

@interface RTRCommandOrientedContent ()

@property (nonatomic, copy) RTRNodeContentDataInitBlock defaultDataInitBlock;

@property (nonatomic, readonly) NSMapTable *dataInitBlocksByCommandClass;

@property (nonatomic, readonly) NSMapTable *dataUpdateBlocksByCommandClass;

@end


@implementation RTRCommandOrientedContent

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _dataInitBlocksByCommandClass = [NSMapTable strongToStrongObjectsMapTable];
    _dataUpdateBlocksByCommandClass = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - Blocks

- (void)setDefaultDataInitBlock:(RTRNodeContentDataInitBlock)block {
    _defaultDataInitBlock = [block copy];
}

- (void)bindCommandClass:(Class)commandClass toDataInitBlock:(RTRNodeContentDataInitBlock)block {
    [self.dataInitBlocksByCommandClass setObject:[block copy] forKey:commandClass];
}

- (void)bindCommandClass:(Class)commandClass toDataUpdateBlock:(RTRNodeContentDataUpdateBlock)block {
    [self.dataUpdateBlocksByCommandClass setObject:[block copy] forKey:commandClass];
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
            _data = block(command);
        }
        
        NSAssert(_data != nil, @""); // TODO
    } else {
        RTRNodeContentDataUpdateBlock block = [self.dataUpdateBlocksByCommandClass objectForKey:[command class]];
        
        if (block) {
            block(_data, command, updateContext.animated);
        }
    }
}

@end
