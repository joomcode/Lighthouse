//
//  RTRBasicNodeContentProvider.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRBasicNodeContentProvider.h"
#import "RTRNode.h"

@interface RTRBasicNodeContentProvider ()

@property (nonatomic, strong) NSMapTable *blocksByNodes;
@property (nonatomic, strong) NSMapTable *blocksByNodeClasses;

@end


@implementation RTRBasicNodeContentProvider

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _blocksByNodes = [NSMapTable strongToStrongObjectsMapTable];
    _blocksByNodeClasses = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - Setup

- (void)bindNode:(id<RTRNode>)node toBlock:(RTRNodeContentProvidingBlock)block {
    [self.blocksByNodes setObject:[block copy] forKey:node];
}

- (void)bindNodes:(NSArray *)nodes toBlock:(RTRNodeContentProvidingBlock)block {
    for (id<RTRNode> node in nodes) {
        [self bindNode:node toBlock:block];
    }
}

- (void)bindNodeClass:(Class)nodeClass toBlock:(RTRNodeContentProvidingBlock)block {
    [self.blocksByNodeClasses setObject:[block copy] forKey:nodeClass];
}

#pragma mark - RTRNodeContentProvider

- (id<RTRNodeContent>)contentForNode:(id<RTRNode>)node {
    RTRNodeContentProvidingBlock block = [self blockForNode:node];
    return block ? block(node) : nil;
}

- (RTRNodeContentProvidingBlock)blockForNode:(id<RTRNode>)node {
    RTRNodeContentProvidingBlock block = [self.blocksByNodes objectForKey:node];
    
    if (!block) {
        block = [self.blocksByNodeClasses objectForKey:[node class]];
    }
    
    return block;
}

@end