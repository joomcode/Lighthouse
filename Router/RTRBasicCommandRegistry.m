//
//  RTRBasicCommandRegistry.m
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRBasicCommandRegistry.h"
#import "RTRCommand.h"
#import "RTRTarget.h"

@interface RTRBasicCommandRegistry ()

@property (nonatomic, strong) NSMapTable *blocksByCommandClass;

@end


@implementation RTRBasicCommandRegistry

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _blocksByCommandClass = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - Setup

- (void)bindCommandClass:(Class)commandClass toTarget:(id<RTRTarget>)target {
    [self bindCommandClass:commandClass toBlock:^id<RTRTarget>(id<RTRCommand> command) {
        return target;
    }];
}

- (void)bindCommandClass:(Class)commandClass toTargetWithActiveNode:(id<RTRNode>)node {
    [self bindCommandClass:commandClass toTarget:[RTRTarget withActiveNode:node]];
}

- (void)bindCommandClass:(Class)commandClass toTargetWithInactiveNode:(id<RTRNode>)node {
    [self bindCommandClass:commandClass toTarget:[RTRTarget withInactiveNode:node]];
}

- (void)bindCommandClass:(Class)commandClass toBlock:(RTRCommandTargetProvidingBlock)block {
    [self.blocksByCommandClass setObject:[block copy] forKey:commandClass];
}

#pragma mark - RTRCommandRegistry

- (id<RTRTarget>)targetForCommand:(id<RTRCommand>)command {
    RTRCommandTargetProvidingBlock block = [self.blocksByCommandClass objectForKey:[command class]];
    return block ? block(command) : nil;
}

@end
