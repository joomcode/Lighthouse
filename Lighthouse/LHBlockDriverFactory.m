//
//  LHBlockDriverFactory.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHBlockDriverFactory.h"
#import "LHNode.h"
#import "LHDriverTools.h"

@interface LHBlockDriverFactory ()

@property (nonatomic, strong) NSMapTable<id<LHNode>, LHDriverFactoryBlock> *blocksByNodes;
@property (nonatomic, strong) NSMapTable<Class, LHDriverFactoryBlock> *blocksByNodeClasses;

@end


@implementation LHBlockDriverFactory

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _blocksByNodes = [NSMapTable strongToStrongObjectsMapTable];
    _blocksByNodeClasses = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - Setup

- (void)bindNode:(id<LHNode>)node toBlock:(LHDriverFactoryBlock)block {
    [self.blocksByNodes setObject:[block copy] forKey:node];
}

- (void)bindNodes:(NSArray<id<LHNode>> *)nodes toBlock:(LHDriverFactoryBlock)block {
    for (id<LHNode> node in nodes) {
        [self bindNode:node toBlock:block];
    }
}

- (void)bindNodeClass:(Class)nodeClass toBlock:(LHDriverFactoryBlock)block {
    [self.blocksByNodeClasses setObject:[block copy] forKey:nodeClass];
}

#pragma mark - LHDriverFactory

- (id<LHDriver>)driverForNode:(id<LHNode>)node withTools:(LHDriverTools *)tools {
    LHDriverFactoryBlock block = [self blockForNode:node];
    return block ? block(node, tools) : nil;
}

- (LHDriverFactoryBlock)blockForNode:(id<LHNode>)node {
    LHDriverFactoryBlock block = [self.blocksByNodes objectForKey:node];
    
    if (!block) {
        block = [self.blocksByNodeClasses objectForKey:[node class]];
    }
    
    return block;
}

@end
