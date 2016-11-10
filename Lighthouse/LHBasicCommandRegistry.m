//
//  LHBasicCommandRegistry.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHBasicCommandRegistry.h"
#import "LHCommand.h"
#import "LHTarget.h"

@interface LHBasicCommandRegistry ()

@property (nonatomic, strong) NSMapTable *blocksByCommandClass;

@end


@implementation LHBasicCommandRegistry

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _blocksByCommandClass = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - Setup

- (void)bindCommandClass:(Class)commandClass toTarget:(LHTarget *)target {
    [self bindCommandClass:commandClass toBlock:^LHTarget *(id<LHCommand> command) {
        return target;
    }];
}

- (void)bindCommandClass:(Class)commandClass toTargetWithActiveNode:(id<LHNode>)node {
    [self bindCommandClass:commandClass toTarget:[LHTarget withActiveNode:node]];
}

- (void)bindCommandClass:(Class)commandClass toTargetWithInactiveNode:(id<LHNode>)node {
    [self bindCommandClass:commandClass toTarget:[LHTarget withInactiveNode:node]];
}

- (void)bindCommandClass:(Class)commandClass toTargetWithActiveNode:(id<LHNode>)node origin:(LHRouteHintOrigin)origin {
    LHRouteHint *hint = [[LHRouteHint alloc] initWithNodes:nil edges:nil origin:origin];
    [self bindCommandClass:commandClass toTarget:[LHTarget withActiveNode:node routeHint:hint]];
}

- (void)bindCommandClass:(Class)commandClass toTargetWithInactiveNode:(id<LHNode>)node origin:(LHRouteHintOrigin)origin {
    LHRouteHint *hint = [[LHRouteHint alloc] initWithNodes:nil edges:nil origin:origin];
    [self bindCommandClass:commandClass toTarget:[LHTarget withInactiveNode:node routeHint:hint]];
}

- (void)bindCommandClass:(Class)commandClass toBlock:(LHCommandTargetProvidingBlock)block {
    [self.blocksByCommandClass setObject:[block copy] forKey:commandClass];
}

#pragma mark - LHCommandRegistry

- (LHTarget *)targetForCommand:(id<LHCommand>)command {
    LHCommandTargetProvidingBlock block = [self.blocksByCommandClass objectForKey:[command class]];
    return block ? block(command) : nil;
}

@end
