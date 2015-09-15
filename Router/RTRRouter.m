//
//  RTRRouter.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRRouter.h"
#import "RTRNode.h"
#import "RTRNodeContent.h"
#import "RTRGraph.h"
#import "RTRNodeStateData.h"
#import "RTRCommandRegistry.h"
#import "RTRNodeContentProvider.h"
#import "RTRNodeChildrenState.h"
#import "RTRNodeContentUpdateContextImpl.h"

@interface RTRRouter ()

@property (nonatomic, strong) RTRGraph *graph;

@property (nonatomic, strong) NSMapTable *stateDataByNode;

@end


@implementation RTRRouter

#pragma mark - Config stuff

- (id<RTRNode>)rootNode {
    return self.graph.rootNode;
}

- (void)setRootNode:(id<RTRNode>)rootNode {
    self.graph = [[RTRGraph alloc] initWithRootNode:rootNode];
}

- (id<RTRNodeChildrenState>)rootChildrenState {
    return [[RTRNodeChildrenState alloc] initWithInitializedChildren:nil activeChildren:[NSOrderedSet orderedSetWithObject:self.rootNode]];
}

#pragma mark - Command execution

- (void)executeCommand:(id<RTRCommand>)command animated:(BOOL)animated {
    id<RTRNode> targetNode = [self.commandRegistry nodeForCommand:command];
    NSAssert(targetNode != nil, @""); // TODO
    
    NSOrderedSet *pathToTargetNode = [self.graph pathToNode:targetNode];
    NSAssert(pathToTargetNode != nil, @""); // TODO
    
    [pathToTargetNode enumerateObjectsUsingBlock:^(id<RTRNode> node, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [self touchNode:node withCommand:command state:RTRNodeStateActive];
            return;
        }
        
        id<RTRNode> parentNode = pathToTargetNode[idx - 1];
        [self touchParentNode:parentNode withNewChildNode:node command:command];
        
        [self performNodeContentUpdate:parentNode animated:YES];
        
        // TODO: figure out animations (queue or something like that?)
    }];
}

- (void)touchParentNode:(id<RTRNode>)parentNode withNewChildNode:(id<RTRNode>)newChildNode command:(id<RTRCommand>)command {
    RTRNodeStateData *parentStateData = [self stateDataForNode:parentNode];
    id<RTRNodeChildrenState> oldChildrenState = parentStateData.childrenState;
    
    id<RTRNodeChildrenState> newChildrenState = [parentNode activateChild:newChildNode withCurrentState:oldChildrenState];
    parentStateData.childrenState = newChildrenState;
    
    [self deactiveChildrenOfNode:parentNode];
    [self touchChildrenOfNode:parentNode withCommand:command];
}

- (void)deactiveChildrenOfNode:(id<RTRNode>)parentNode {
    id<RTRNodeChildrenState> childrenState = [self stateDataForNode:parentNode].childrenState;
    
    for (id<RTRNode> child in [parentNode allChildren]) {
        if (![childrenState.initializedChildren containsObject:child] && ![childrenState.activeChildren containsObject:child]) {
            [self resetStateDataForNode:child];
        }
    }
}

- (void)touchChildrenOfNode:(id<RTRNode>)parentNode withCommand:(id<RTRCommand>)command {
    id<RTRNodeChildrenState> childrenState = [self stateDataForNode:parentNode].childrenState;
    
    for (id<RTRNode> node in childrenState.initializedChildren) {
        [self touchNode:node withCommand:command state:RTRNodeStateInitialized];
    }
    
    for (id<RTRNode> node in childrenState.activeChildren) {
        [self touchNode:node withCommand:command state:RTRNodeStateActive];
    }
}

- (void)touchNode:(id<RTRNode>)node withCommand:(id<RTRCommand>)command state:(RTRNodeState)state {
    [self stateDataForNode:node].state = state;
    [self setupNodeContent:node withCommand:command];
}

- (void)setupNodeContent:(id<RTRNode>)node withCommand:(id<RTRCommand>)command {
    RTRNodeStateData *stateData = [self stateDataForNode:node];
    
    if (!stateData.contentByProvider) {
        stateData.contentByProvider = [self createContentTableForNode:node];
    }
    
    for (id<RTRNodeContent> content in [stateData.contentByProvider objectEnumerator]) {
        [content setupDataWithCommand:command];
    }
}

- (NSMapTable *)createContentTableForNode:(id<RTRNode>)node {
    NSMapTable *contentByProvider = [NSMapTable strongToStrongObjectsMapTable];
    
    for (id<RTRNodeContentProvider> provider in self.nodeContentProviders) {
        id<RTRNodeContent> content = [provider contentForNode:node];
        if (content) {
            [contentByProvider setObject:content forKey:provider];
        }
    }
    
    return contentByProvider;
}

- (void)performNodeContentUpdate:(id<RTRNode>)node animated:(BOOL)animated {
    RTRNodeStateData *stateData = [self stateDataForNode:node];
    
    for (id<RTRNodeContentProvider> provider in self.nodeContentProviders) {
        NSAssert(stateData.contentByProvider != nil, @""); // TODO
        
        id<RTRNodeContent> content = [stateData.contentByProvider objectForKey:provider];
        if (!content) {
            continue;
        }
        
        RTRNodeContentUpdateContextImpl *contentUpdateContext = [[RTRNodeContentUpdateContextImpl alloc] init];
        contentUpdateContext.animated = animated;
        contentUpdateContext.childrenState = stateData.childrenState;
        contentUpdateContext.contentBlock = ^(id<RTRNode> childNode) {
            return [[self stateDataForNode:childNode].contentByProvider objectForKey:provider];
        };
        
        [content performUpdateWithContext:contentUpdateContext];
    }
}

#pragma mark - Node state

- (NSMapTable *)stateDataByNode {
    if (!_stateDataByNode) {
        _stateDataByNode = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _stateDataByNode;
}

- (RTRNodeStateData *)stateDataForNode:(id<RTRNode>)node {
    RTRNodeStateData *data = [self.stateDataByNode objectForKey:node];
    if (!data) {
        data = [[RTRNodeStateData alloc] init];
        [self.stateDataByNode setObject:data forKey:node];
    }
    return data;
}

- (void)resetStateDataForNode:(id<RTRNode>)node {
    [self.stateDataByNode removeObjectForKey:node];
}

@end
