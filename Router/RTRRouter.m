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
#import "RTRNodeData.h"
#import "RTRCommandRegistry.h"
#import "RTRNodeContentProvider.h"
#import "RTRNodeChildrenState.h"
#import "RTRNodeContentUpdateContextImpl.h"
#import "RTRNodeContentFeedbackChannelImpl.h"

@interface RTRRouter ()

@property (nonatomic, strong) RTRGraph *graph;

@property (nonatomic, strong) NSMapTable *dataByNode;
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

#pragma mark - Command execution

- (void)executeCommand:(id<RTRCommand>)command animated:(BOOL)animated {
    id<RTRNode> targetNode = [self.commandRegistry nodeForCommand:command];
    NSAssert(targetNode != nil, @""); // TODO
    
    NSOrderedSet *pathToTargetNode = [self.graph pathToNode:targetNode];
    NSAssert(pathToTargetNode != nil, @""); // TODO
    
    [self activateNodePath:pathToTargetNode];
    
    [self updateContentForNodes:pathToTargetNode withCommand:command animated:animated];
}

#pragma mark - Node state manipulation

- (void)activateNodePath:(NSOrderedSet *)nodePath {
    for (NSInteger i = 0; i < nodePath.count; ++i) {
        if (i == 0) {
            [self dataForNode:nodePath[0]].state = RTRNodeStateActive;
        } else {
            [self activateNewChildNode:nodePath[i] ofParentNode:nodePath[i - 1]];
        }
    }
    
    [self updateActiveNodes];
}

- (void)activateNewChildNode:(id<RTRNode>)childNode ofParentNode:(id<RTRNode>)parentNode {
    RTRNodeData *parentData = [self dataForNode:parentNode];
    parentData.childrenState = [parentNode activateChild:childNode withCurrentState:parentData.childrenState];
    
    [self updateNodeChildrenState:parentNode];
}

- (void)updateNodeChildrenState:(id<RTRNode>)parentNode {
    id<RTRNodeChildrenState> childrenState = [self dataForNode:parentNode].childrenState;
    
    for (id<RTRNode> childNode in childrenState.initializedChildren) {
        [self dataForNode:childNode].state = [childrenState.activeChildren containsObject:childNode] ? RTRNodeStateActive : RTRNodeStateInitialized;
    }
    
    for (id<RTRNode> childNode in [parentNode allChildren]) {
        if (![childrenState.initializedChildren containsObject:childNode]) {
            [self resetDataForNode:childNode];
        }
    }
}

#pragma mark - Node content manipulation

- (void)updateContentForNodes:(NSOrderedSet *)nodes withCommand:(id<RTRCommand>)command animated:(BOOL)animated {
    [self updateNodeContentRecursively:nodes[0] withCommand:command animated:animated];
}

- (void)updateNodeContentRecursively:(id<RTRNode>)node withCommand:(id<RTRCommand>)command animated:(BOOL)animated {
    RTRNodeData *data = [self dataForNode:node];
    
    for (id<RTRNode> childNode in data.childrenState.initializedChildren) {
        [self updateNodeContentRecursively:childNode withCommand:command animated:NO];
    }
        
    [self updateNodeContent:node withCommand:command animated:animated];
}

- (void)updateNodeContent:(id<RTRNode>)node withCommand:(id<RTRCommand>)command animated:(BOOL)animated {
    RTRNodeData *data = [self dataForNode:node];
    
    if (!data.content) {
        data.content = [self createContentForNode:node];
    }
    
    [data.content updateWithContext:
        [[RTRNodeContentUpdateContextImpl alloc] initWithAnimated:animated
                                                          command:command
                                                    childrenState:data.childrenState
                                                     contentBlock:^id<RTRNodeContent>(id<RTRNode> node) {
                                                         return [self dataForNode:node].content;
                                                     }]];
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
            [weakSelf activateNewChildNode:child ofParentNode:node];
            [weakSelf updateActiveNodes];
        };
        
        content.feedbackChannel = feedbackChannel;
    }
    
    return content;
}

#pragma mark - Active nodes

- (void)updateActiveNodes {
    self.activeNodes = [self calculateActiveNodes];
}

- (NSSet *)calculateActiveNodes {
    NSMutableSet *activeNodes = [[NSMutableSet alloc] init];
    [self calculateActiveNodesRecursivelyWithCurrentNode:self.rootNode activeNodes:activeNodes];
    return [activeNodes copy];
}

- (void)calculateActiveNodesRecursivelyWithCurrentNode:(id<RTRNode>)node activeNodes:(NSMutableSet *)activeNodes {
    RTRNodeData *data = [self dataForNode:node];
    if (data.state != RTRNodeStateActive) {
        return;
    }
    
    [activeNodes addObject:node];
    
    for (id<RTRNode> child in data.childrenState.activeChildren) {
        [self calculateActiveNodesRecursivelyWithCurrentNode:child activeNodes:activeNodes];
    }
}

#pragma mark - Node data

- (NSMapTable *)dataByNode {
    if (!_dataByNode) {
        _dataByNode = [NSMapTable strongToStrongObjectsMapTable];
    }
    return _dataByNode;
}

- (RTRNodeData *)dataForNode:(id<RTRNode>)node {
    RTRNodeData *data = [self.dataByNode objectForKey:node];
    if (!data) {
        data = [self createDataForNode:node];
        [self.dataByNode setObject:data forKey:node];
    }
    return data;
}

- (RTRNodeData *)createDataForNode:(id<RTRNode>)node {
    RTRNodeData *data = [[RTRNodeData alloc] init];
    data.childrenState = [node activateChild:[node defaultActiveChild] withCurrentState:nil];
    return data;
}

- (void)resetDataForNode:(id<RTRNode>)node {
    [self.dataByNode removeObjectForKey:node];
}

@end