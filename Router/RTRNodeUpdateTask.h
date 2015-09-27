//
//  RTRNodeUpdateTask.h
//  Router
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRTask.h"

@protocol RTRNode;
@protocol RTRCommand;
@protocol RTRNodeContentProvider;
@class RTRGraph;
@class RTRNodeDataStorage;


@interface RTRNodeUpdateTask : NSObject <RTRTask>

@property (nonatomic, strong, readonly) RTRNodeDataStorage *nodeDataStorage;
@property (nonatomic, strong, readonly) id<RTRNodeContentProvider> nodeContentProvider;
@property (nonatomic, strong, readonly) RTRGraph *graph;
@property (nonatomic, getter = isAnimated, readonly) BOOL animated;

- (instancetype)initWithNodeDataStorage:(RTRNodeDataStorage *)nodeDataStorage
                    nodeContentProvider:(id<RTRNodeContentProvider>)nodeContentProvider
                                  graph:(RTRGraph *)graph
                               animated:(BOOL)animated;

@end


@interface RTRNodeUpdateTask (Abstract)

- (id<RTRCommand>)command;

- (void)updateNodes;

- (BOOL)shouldUpdateContentForNode:(id<RTRNode>)node;

@end