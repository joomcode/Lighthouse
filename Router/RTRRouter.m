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
#import "RTRNodeContentFeedbackChannelImpl.h"

@interface RTRRouter ()

@property (nonatomic, strong) RTRGraph *graph;

@property (nonatomic, strong) NSMapTable *stateDataByNode;
@property (nonatomic, strong) NSSet *activeNodes;

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
    
    [self updateActiveNodes];
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
    
    if (command) {
        [self setupNodeContent:node withCommand:command];
    }
}

- (void)setupNodeContent:(id<RTRNode>)node withCommand:(id<RTRCommand>)command {
    RTRNodeStateData *stateData = [self stateDataForNode:node];
    
    if (!stateData.content) {
        stateData.content = [self createContentForNode:node];
    }
    
    [stateData.content setupDataWithCommand:command];
}

- (id<RTRNodeContent>)createContentForNode:(id<RTRNode>)node {
    id<RTRNodeContent> content = [self.nodeContentProvider contentForNode:node];
    if (!content) {
        return nil;
    }
    
    if ([content respondsToSelector:@selector(setFeedbackChannel:)]) {
        RTRNodeContentFeedbackChannelImpl *feedbackChannel = [[RTRNodeContentFeedbackChannelImpl alloc] init];
        
        __weak __typeof(self) weakSelf = self;
        feedbackChannel.childActivedBlock = ^(id<RTRNode> child) {
            [weakSelf touchParentNode:node withNewChildNode:child command:nil];
            [weakSelf updateActiveNodes];
        };
        
        content.feedbackChannel = feedbackChannel;
    }
    
    return content;
}

- (void)performNodeContentUpdate:(id<RTRNode>)node animated:(BOOL)animated {
    RTRNodeStateData *stateData = [self stateDataForNode:node];
    
    if (!stateData.content) {
        return;
    }
    
    [stateData.content performUpdateWithContext:
        [[RTRNodeContentUpdateContextImpl alloc] initWithAnimated:animated
                                                    childrenState:stateData.childrenState
                                                     contentBlock:^id<RTRNodeContent>(id<RTRNode> node) {
                                                         return [self stateDataForNode:node].content;
                                                     }]];
}

- (void)updateActiveNodes {
    self.activeNodes = [self calculateActiveNodes];
}

- (NSSet *)calculateActiveNodes {
    NSMutableSet *activeNodes = [[NSMutableSet alloc] init];
    [self calculateActiveNodesRecursivelyWithCurrentNode:self.rootNode activeNodes:activeNodes];
    return [activeNodes copy];
}

- (void)calculateActiveNodesRecursivelyWithCurrentNode:(id<RTRNode>)node activeNodes:(NSMutableSet *)activeNodes {
    RTRNodeStateData *stateData = [self stateDataForNode:node];
    if (stateData.state != RTRNodeStateActive) {
        return;
    }
    
    [activeNodes addObject:node];
    
    for (id<RTRNode> child in stateData.childrenState.activeChildren) {
        [self calculateActiveNodesRecursivelyWithCurrentNode:child activeNodes:activeNodes];
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
