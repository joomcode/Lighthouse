//
//  LHTransitionStyleRegistry.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 06/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHTransitionStyleRegistry.h"
#import "LHNode.h"

@implementation LHTransitionStyleEntry

- (instancetype)initWithTransitionStyle:(id)transitionStyle
                             sourceNode:(id<LHNode>)sourceNode
                        destinationNode:(id<LHNode>)destinationNode {
    self = [super init];
    if (!self) return nil;
    
    _transitionStyle = transitionStyle;
    _sourceNode = sourceNode;
    _destinationNode = destinationNode;
    
    return self;
}

@end


@interface LHTransitionStyleRegistry ()

@property (nonatomic, strong, readonly) NSMutableArray<LHTransitionStyleEntry *> *entries;
@property (nonatomic, strong) LHTransitionStyleEntry *defaultEntry;

@end


@implementation LHTransitionStyleRegistry

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    _entries = [NSMutableArray array];
    
    return self;
}

#pragma mark - Registry

- (void)registerTransitionStyle:(id)transitionStyle forSourceNode:(id<LHNode>)sourceNode destinationNode:(id<LHNode>)destinationNode {
    if (!sourceNode && !destinationNode) {
        NSAssert(NO, @""); // TODO;
        return;
    }
    
    [self.entries addObject:[[LHTransitionStyleEntry alloc] initWithTransitionStyle:transitionStyle
                                                                         sourceNode:sourceNode
                                                                    destinationNode:destinationNode]];
}

- (void)registerDefaultTransitionStyle:(id)transitionStyle {
    self.defaultEntry = [[LHTransitionStyleEntry alloc] initWithTransitionStyle:transitionStyle
                                                                     sourceNode:nil
                                                                destinationNode:nil];
}

@end


@implementation LHTransitionStyleRegistry (Query)

- (LHTransitionStyleEntry *)entryForSourceNodes:(NSSet<id<LHNode>> *)sourceNodes destinationNodes:(NSSet<id<LHNode>> *)destinationNodes {
    for (LHTransitionStyleEntry *entry in self.entries) {
        if (entry.sourceNode && ![sourceNodes containsObject:entry.sourceNode]) {
            continue;
        }
        
        if (entry.destinationNode && ![destinationNodes containsObject:entry.destinationNode]) {
            continue;
        }
        
        return entry;
    }
    
    return self.defaultEntry;
}

@end
