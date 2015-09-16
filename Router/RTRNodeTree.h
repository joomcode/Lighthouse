//
//  RTRNodeTree.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;

@interface RTRNodeTree : NSObject <NSCopying>

- (NSSet *)allNodes;

- (id<RTRNode>)previousNode:(id<RTRNode>)node;
- (NSOrderedSet *)nextNodes:(id<RTRNode>)node;

- (NSOrderedSet *)pathToNode:(id<RTRNode>)node;

@end


// TODO: split into mutable subclass

@interface RTRNodeTree (Mutation)

- (void)addNode:(id<RTRNode>)node afterNodeOrNil:(id<RTRNode>)previousNode;

- (void)addBranch:(NSArray *)nodes afterNodeOrNil:(id<RTRNode>)previousNode;

@end
