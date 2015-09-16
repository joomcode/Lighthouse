//
//  RTRNodeContentUpdateContextImpl.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentUpdateContextImpl.h"

@interface RTRNodeContentUpdateContextImpl ()

@property (nonatomic, copy, readonly) id<RTRNodeContent> (^contentBlock)(id<RTRNode> node);

@end


@implementation RTRNodeContentUpdateContextImpl

#pragma mark - Init

- (instancetype)init {
    return [self initWithAnimated:NO command:nil childrenState:nil contentBlock:nil];
}

- (instancetype)initWithAnimated:(BOOL)animated
                         command:(id<RTRCommand>)command
                   childrenState:(id<RTRNodeChildrenState>)childrenState
                    contentBlock:(id<RTRNodeContent> (^)(id<RTRNode>))contentBlock
{
    NSParameterAssert(command != nil);
    NSParameterAssert(childrenState != nil);
    NSParameterAssert(contentBlock != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _animated = animated;
    _command = command;
    _childrenState = childrenState;
    _contentBlock = [contentBlock copy];
    
    return self;
}

#pragma mark - RTRNodeContentUpdateContext

@synthesize animated = _animated;
@synthesize command = _command;
@synthesize childrenState = _childrenState;

- (id<RTRNodeContent>)contentForNode:(id<RTRNode>)node {
    return self.contentBlock(node);
}

@end
