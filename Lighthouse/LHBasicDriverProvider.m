//
//  LHBasicDriverProvider.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHBasicDriverProvider.h"
#import "LHNode.h"
#import "LHDriverProviderContext.h"

@interface LHBasicDriverProvider ()

@property (nonatomic, strong) NSMapTable<id<LHNode>, LHDriverProvidingBlock> *blocksByNodes;
@property (nonatomic, strong) NSMapTable<Class, LHDriverProvidingBlock> *blocksByNodeClasses;

@end


@implementation LHBasicDriverProvider

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _blocksByNodes = [NSMapTable strongToStrongObjectsMapTable];
    _blocksByNodeClasses = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - Setup

- (void)bindNode:(id<LHNode>)node toBlock:(LHDriverProvidingBlock)block {
    [self.blocksByNodes setObject:[block copy] forKey:node];
}

- (void)bindNodes:(NSArray<id<LHNode>> *)nodes toBlock:(LHDriverProvidingBlock)block {
    for (id<LHNode> node in nodes) {
        [self bindNode:node toBlock:block];
    }
}

- (void)bindNodeClass:(Class)nodeClass toBlock:(LHDriverProvidingBlock)block {
    [self.blocksByNodeClasses setObject:[block copy] forKey:nodeClass];
}

#pragma mark - LHDriverProvider

- (id<LHDriver>)driverForNode:(id<LHNode>)node withContext:(id<LHDriverProviderContext>)context {
    LHDriverProvidingBlock block = [self blockForNode:node];
    return block ? block(node, context) : nil;
}

- (LHDriverProvidingBlock)blockForNode:(id<LHNode>)node {
    LHDriverProvidingBlock block = [self.blocksByNodes objectForKey:node];
    
    if (!block) {
        block = [self.blocksByNodeClasses objectForKey:[node class]];
    }
    
    return block;
}

@end
