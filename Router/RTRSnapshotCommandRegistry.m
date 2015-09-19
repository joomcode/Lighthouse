//
//  RTRSnapshotCommandRegistry.m
//  Router
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRSnapshotCommandRegistry.h"

@interface RTRSnapshotCommandRegistry ()

@property (nonatomic, readonly) NSMapTable *nodesByCommands;

@end


@implementation RTRSnapshotCommandRegistry

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _nodesByCommands = [NSMapTable weakToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - Setup

- (void)bindCommand:(id<RTRCommand>)command toNodes:(NSSet *)nodes {
    [self.nodesByCommands setObject:nodes forKey:command];
}

#pragma mark - RTRCommandRegistry

- (NSSet *)nodesForCommand:(id<RTRCommand>)command {
    return [self.nodesByCommands objectForKey:command];
}

@end
