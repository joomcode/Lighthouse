//
//  LHTransitionStyleRegistry.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 06/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHTransitionStyleRegistry.h"
#import "LHNode.h"

@interface LHTransitionStyleRegistryKey : NSObject

@property (nonatomic, strong, readonly, nullable) id<LHNode> source;
@property (nonatomic, strong, readonly, nullable) id<LHNode> destination;

- (instancetype)initWithSource:(id<LHNode>)source destination:(id<LHNode>)destination;

@end


@implementation LHTransitionStyleRegistryKey

- (instancetype)initWithSource:(id<LHNode>)source destination:(id<LHNode>)destination {
    self = [super init];
    if (!self) return nil;
    
    _source = source;
    _destination = destination;
    
    return self;
}

@end


@interface LHTransitionStyleRegistry ()

@property (nonatomic, strong, readonly) NSMutableArray<LHTransitionStyleRegistryKey *> *keys;
@property (nonatomic, strong, readonly) NSMutableArray<id> *styles;

@property (nonatomic, strong) id defaultStyle;

@end


@implementation LHTransitionStyleRegistry

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _keys = [NSMutableArray array];
    _styles = [NSMutableArray array];
    
    return self;
}

#pragma mark - Registry

- (void)registerTransitionStyle:(id)transitionStyle forSourceNode:(id<LHNode>)sourceNode destinationNode:(id<LHNode>)destinationNode {
    if (!sourceNode && !destinationNode) {
        NSAssert(NO, @""); // TODO;
        return;
    }
    
    LHTransitionStyleRegistryKey *key = [[LHTransitionStyleRegistryKey alloc] initWithSource:sourceNode destination:destinationNode];
    
    [self.keys addObject:key];
    [self.styles addObject:transitionStyle];
}

- (void)registerDefaultTransitionStyle:(id)transitionStyle {
    self.defaultStyle = transitionStyle;
}

- (id)transitionStyleForSourceNodes:(NSSet<id<LHNode>> *)sourceNodes destinationNodes:(NSSet<id<LHNode>> *)destinationNodes {
    __block id result = nil;
    
    [self.keys enumerateObjectsUsingBlock:^(LHTransitionStyleRegistryKey *key, NSUInteger idx, BOOL *stop) {
        if (key.source && ![sourceNodes containsObject:key.source]) {
            return;
        }
        
        if (key.destination && ![destinationNodes containsObject:key.destination]) {
            return;
        }
        
        result = self.styles[idx];
        *stop = YES;
    }];
    
    return result ?: self.defaultStyle;
}

- (id<LHNode>)sourceNodeForTransitionStyle:(id)transitionStyle {
    NSUInteger index = [self.styles indexOfObject:transitionStyle];
    return index != NSNotFound ? self.keys[index].source : nil;
}

- (id<LHNode>)destinationNodeForTransitionStyle:(id)transitionStyle {
    NSUInteger index = [self.styles indexOfObject:transitionStyle];
    return index != NSNotFound ? self.keys[index].destination : nil;
}

@end
