//
//  RTRComponents.h
//  Router
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTRGraph;
@class RTRNodeDataStorage;
@protocol RTRNodeContentProvider;
@protocol RTRCommandRegistry;

@interface RTRComponents : NSObject

@property (nonatomic, strong) RTRGraph *graph;

@property (nonatomic, strong) RTRNodeDataStorage *nodeDataStorage;

@property (nonatomic, strong) id<RTRNodeContentProvider> nodeContentProvider;

@property (nonatomic, strong) id<RTRCommandRegistry> commandRegistry;

@end
