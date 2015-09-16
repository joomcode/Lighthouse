//
//  RTRTabNode.m
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRTabNode.h"
#import "RTRNodeChildrenState.h"

@interface RTRTabNode ()

@property (nonatomic, copy, readonly) NSOrderedSet *children;

@end


@implementation RTRTabNode

#pragma mark - Init

- (instancetype)init {
    return [self initWithChildren:nil];
}

- (instancetype)initWithChildren:(NSOrderedSet *)children {
    NSParameterAssert(children.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    _children = [children copy];
    
    return self;
}

#pragma mark - PXRouterNode

- (NSSet *)allChildren {
    return [self.children set];
}

- (id<RTRNode>)defaultActiveChild {
    return self.children.firstObject;
}

- (id<RTRNodeChildrenState>)activateChild:(id<RTRNode>)child withCurrentState:(id<RTRNodeChildrenState>)currentState {
    NSInteger childIndex = [self.children indexOfObject:child];
    if (childIndex == NSNotFound) {
        return nil;
    }
    
    return [[RTRNodeChildrenState alloc] initWithInitializedChildren:self.children
                                              activeChildrenIndexSet:[NSIndexSet indexSetWithIndex:childIndex]];
}

@end
