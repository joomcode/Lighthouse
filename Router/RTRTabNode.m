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

@property (nonatomic, copy, readonly) NSOrderedSet *orderedChildren;

@property (nonatomic, strong) id<RTRNodeChildrenState> childrenState;

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
    
    _orderedChildren = [children copy];
    
    return self;
}

#pragma mark - PXRouterNode

@synthesize childrenState = _childrenState;

- (NSSet *)allChildren {
    return [self.orderedChildren set];
}

- (void)resetChildrenState {
    self.childrenState = [[RTRNodeChildrenState alloc] initWithInitializedChildren:self.orderedChildren
                                                            activeChildrenIndexSet:[NSIndexSet indexSetWithIndex:0]];
}

- (BOOL)activateChildren:(NSSet *)children {
    NSAssert(children.count == 1, @""); // TODO
    
    NSInteger childIndex = [self.orderedChildren indexOfObject:children.anyObject];
    if (childIndex == NSNotFound) {
        return NO;
    }
    
    self.childrenState = [[RTRNodeChildrenState alloc] initWithInitializedChildren:self.orderedChildren
                                                            activeChildrenIndexSet:[NSIndexSet indexSetWithIndex:childIndex]];
    
    return YES;
}

@end
