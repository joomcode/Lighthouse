//
//  RTRBasicCommandRegistry.m
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRBasicCommandRegistry.h"
#import "RTRCommand.h"
#import "RTRTargetNodes.h"

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

- (void)bindCommandClass:(Class)commandClass toActiveNodeTarget:(id<RTRNode>)node {
    [self bindCommandClass:commandClass toTargetNodes:[RTRTargetNodes withActiveNode:node]];
}

- (void)bindCommandClass:(Class)commandClass toInactiveNodeTarget:(id<RTRNode>)node {
    [self bindCommandClass:commandClass toTargetNodes:[RTRTargetNodes withInactiveNode:node]];
}

- (void)bindCommandClass:(Class)commandClass toTargetNodes:(RTRTargetNodes *)targetNodes {
    [self bindCommandClass:commandClass toBlock:^RTRTargetNodes *(id<RTRCommand> command) {
        return targetNodes;
    }];
}

- (void)bindCommandClass:(Class)commandClass toBlock:(RTRCommandTargetNodesProvidingBlock)block {
    [self.blocksByCommandClass setObject:[block copy] forKey:commandClass];
}

#pragma mark - RTRCommandRegistry

- (RTRTargetNodes *)targetNodesForCommand:(id<RTRCommand>)command {
    RTRCommandTargetNodesProvidingBlock block = [self.blocksByCommandClass objectForKey:[command class]];
    return block ? block(command) : nil;
}

@end
