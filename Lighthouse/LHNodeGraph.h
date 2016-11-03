//
//  LHNodeGraph.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNode;
@class LHNodeTree;

NS_ASSUME_NONNULL_BEGIN


@interface LHNodeGraph : NSObject

@property (nonatomic, strong, readonly) id<LHNode> rootNode;

- (instancetype)initWithRootNode:(id<LHNode>)rootNode;

- (instancetype)init NS_UNAVAILABLE;


- (nullable NSOrderedSet<id<LHNode>> *)pathToNode:(id<LHNode>)node;

- (nullable LHNodeTree *)pathsToNodes:(NSSet<id<LHNode>> *)nodes;


- (LHNodeTree *)initializedNodesTree;

- (LHNodeTree *)activeNodesTree;

@end


NS_ASSUME_NONNULL_END
