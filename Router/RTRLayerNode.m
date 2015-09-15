//
//  RTRLayerNode.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRLayerNode.h"
#import "RTRNodeChildrenState.h"

@interface RTRLayerNode ()

@property (nonatomic, strong) id<RTRNode> rootNode;

@end

@implementation RTRLayerNode

#pragma mark - Init

- (instancetype)initWithRootNode:(id<RTRNode>)rootNode {
    self = [super init];
    if (!self) return nil;
    
    _rootNode = rootNode;
    
    return self;
}

#pragma mark - RTRNode

- (NSSet *)allChildren {
    return [NSSet setWithObject:self.rootNode];
}

- (id<RTRNodeChildrenState>)activateChild:(id<RTRNode>)child withCurrentState:(id<RTRNodeChildrenState>)currentState {
    return [[RTRNodeChildrenState alloc] initWithInitializedChildren:nil
                                                      activeChildren:[NSOrderedSet orderedSetWithObject:self.rootNode]];
}

@end
