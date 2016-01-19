//
//  RTRBasicDriverProvider.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRBasicDriverProvider.h"
#import "RTRNode.h"

@interface RTRBasicDriverProvider ()

@property (nonatomic, strong) NSMapTable<id<RTRNode>, RTRDriverProvidingBlock> *blocksByNodes;
@property (nonatomic, strong) NSMapTable<Class, RTRDriverProvidingBlock> *blocksByNodeClasses;

@end


@implementation RTRBasicDriverProvider

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _blocksByNodes = [NSMapTable strongToStrongObjectsMapTable];
    _blocksByNodeClasses = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - Setup

- (void)bindNode:(id<RTRNode>)node toBlock:(RTRDriverProvidingBlock)block {
    [self.blocksByNodes setObject:[block copy] forKey:node];
}

- (void)bindNodes:(NSArray *)nodes toBlock:(RTRDriverProvidingBlock)block {
    for (id<RTRNode> node in nodes) {
        [self bindNode:node toBlock:block];
    }
}

- (void)bindNodeClass:(Class)nodeClass toBlock:(RTRDriverProvidingBlock)block {
    [self.blocksByNodeClasses setObject:[block copy] forKey:nodeClass];
}

#pragma mark - RTRDriverProvider

- (id<RTRDriver>)driverForNode:(id<RTRNode>)node {
    RTRDriverProvidingBlock block = [self blockForNode:node];
    return block ? block(node) : nil;
}

- (RTRDriverProvidingBlock)blockForNode:(id<RTRNode>)node {
    RTRDriverProvidingBlock block = [self.blocksByNodes objectForKey:node];
    
    if (!block) {
        block = [self.blocksByNodeClasses objectForKey:[node class]];
    }
    
    return block;
}

@end
