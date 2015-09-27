//
//  RTRGraph.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;
@class RTRNodeTree;

@interface RTRGraph : NSObject

@property (nonatomic, strong, readonly) id<RTRNode> rootNode;

- (instancetype)initWithRootNode:(id<RTRNode>)rootNode;


- (NSOrderedSet *)pathToNode:(id<RTRNode>)node;

- (RTRNodeTree *)pathsToNodes:(NSSet *)nodes;


- (RTRNodeTree *)initializedNodesTree;

- (RTRNodeTree *)activeNodesTree;

@end