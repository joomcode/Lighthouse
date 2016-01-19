//
//  LHComponents.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHComponents.h"

@implementation LHComponents

- (instancetype)initWithGraph:(LHGraph *)graph
              nodeDataStorage:(LHNodeDataStorage *)nodeDataStorage
               driverProvider:(id<LHDriverProvider>)driverProvider
              commandRegistry:(id<LHCommandRegistry>)commandRegistry {
    self = [super init];
    if (!self) return nil;
    
    _graph = graph;
    _nodeDataStorage = nodeDataStorage;
    _driverProvider = driverProvider;
    _commandRegistry = commandRegistry;
    
    return self;
}

@end
