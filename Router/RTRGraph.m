//
//  RTRGraph.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRGraph.h"
#import "RTRNode.h"

@implementation RTRGraph

- (instancetype)init {
    return [self initWithRootNode:nil];
}

- (instancetype)initWithRootNode:(id<RTRNode>)rootNode {
    NSParameterAssert(rootNode != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _rootNode = rootNode;
    
    return self;
}

- (NSOrderedSet *)pathToNode:(id<RTRNode>)node {
    NSMutableOrderedSet *currentPath = [[NSMutableOrderedSet alloc] initWithObject:self.rootNode];
    
    return [self searchForNodeRecursively:node currentPath:currentPath] ? currentPath : nil;
}

- (BOOL)searchForNodeRecursively:(id<RTRNode>)node currentPath:(NSMutableOrderedSet *)currentPath {
    id<RTRNode> parent = currentPath.lastObject;
    
    if ([parent isEqual:node]) {
        return YES;
    }
    
    for (id<RTRNode> child in [parent allChildren]) {
        [currentPath addObject:child];
        
        if ([self searchForNodeRecursively:node currentPath:currentPath]) {
            return YES;
        } else {
            [currentPath removeObjectAtIndex:currentPath.count - 1];
        }
    }
    
    return NO;
}

@end
