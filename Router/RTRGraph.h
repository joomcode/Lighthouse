//
//  RTRGraph.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;

@interface RTRGraph : NSObject

@property (nonatomic, strong, readonly) id<RTRNode> rootNode;

- (instancetype)initWithRootNode:(id<RTRNode>)rootNode;

- (NSOrderedSet *)pathToNode:(id<RTRNode>)node;

@end