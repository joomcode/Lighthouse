//
//  LHComponents.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHComponents.h"
#import "LHNodeDataStorage.h"
#import "LHNodeData.h"
#import "LHDriverProviderImpl.h"

@implementation LHComponents

- (instancetype)initWithGraph:(LHGraph *)graph
              nodeDataStorage:(LHNodeDataStorage *)nodeDataStorage
                driverFactory:(id<LHDriverFactory>)driverFactory
              commandRegistry:(id<LHCommandRegistry>)commandRegistry {
    self = [super init];
    if (!self) return nil;
    
    _graph = graph;
    _nodeDataStorage = nodeDataStorage;
    _driverFactory = driverFactory;
    _commandRegistry = commandRegistry;
    
    _driverProvider = [[LHDriverProviderImpl alloc] initWithBlock:^(id<LHNode> node) {
        return [nodeDataStorage dataForNode:node].driver;
    }];
    
    return self;
}

@end
