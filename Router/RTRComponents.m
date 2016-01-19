//
//  RTRComponents.m
//  Router
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRComponents.h"

@implementation RTRComponents

- (instancetype)initWithGraph:(RTRGraph *)graph
              nodeDataStorage:(RTRNodeDataStorage *)nodeDataStorage
               driverProvider:(id<RTRDriverProvider>)driverProvider
              commandRegistry:(id<RTRCommandRegistry>)commandRegistry {
    self = [super init];
    if (!self) return nil;
    
    _graph = graph;
    _nodeDataStorage = nodeDataStorage;
    _driverProvider = driverProvider;
    _commandRegistry = commandRegistry;
    
    return self;
}

@end
