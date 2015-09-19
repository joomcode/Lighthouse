//
//  RTRBasicCommandRegistry.m
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRBasicCommandRegistry.h"
#import "RTRCommand.h"

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

- (void)bindCommandClass:(Class)commandClass toNode:(id<RTRNode>)node {
    [self bindCommandClass:commandClass toNodes:[NSSet setWithObject:node]];
}

- (void)bindCommandClass:(Class)commandClass toNodes:(NSSet *)nodes {
    [self bindCommandClass:commandClass toBlock:^NSSet *(id<RTRCommand> command) {
        return nodes;
    }];
}

- (void)bindCommandClass:(Class)commandClass toBlock:(RTRCommandNodesProvidingBlock)block {
    [self.blocksByCommandClass setObject:[block copy] forKey:commandClass];
}

#pragma mark - RTRCommandRegistry

- (NSSet *)nodesForCommand:(id<RTRCommand>)command {
    RTRCommandNodesProvidingBlock block = [self.blocksByCommandClass objectForKey:[command class]];
    return block ? block(command) : nil;
}

@end
