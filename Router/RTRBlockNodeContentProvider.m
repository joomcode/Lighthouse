//
//  RTRBlockNodeContentProvider.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRBlockNodeContentProvider.h"

@interface RTRBlockNodeContentProvider ()

@property (nonatomic, strong) NSMapTable *blocksByNodes;

@end

@implementation RTRBlockNodeContentProvider

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _blocksByNodes = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - Setup

- (void)bindNode:(id<RTRNode>)node toBlock:(RTRNodeContentProvidingBlock)block {
    [self.blocksByNodes setObject:[block copy] forKey:node];
}

#pragma mark - RTRNodeContentProvider

- (id<RTRNodeContent>)contentForNode:(id<RTRNode>)node {
    RTRNodeContentProvidingBlock block = [self.blocksByNodes objectForKey:node];
    return block ? block(node) : nil;
}

@end
