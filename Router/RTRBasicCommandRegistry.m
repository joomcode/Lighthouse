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
    [self bindCommandClass:commandClass toBlock:^id<RTRNode>(id<RTRCommand> command) {
        return node;
    }];
}

- (void)bindCommandClass:(Class)commandClass toBlock:(RTRCommandNodeProvidingBlock)block {
    [self.blocksByCommandClass setObject:[block copy] forKey:commandClass];
}

#pragma mark - RTRCommandRegistry

- (id<RTRNode>)nodeForCommand:(id<RTRCommand>)command {
    RTRCommandNodeProvidingBlock block = [self.blocksByCommandClass objectForKey:[command class]];
    return block ? block(command) : nil;
}

@end
