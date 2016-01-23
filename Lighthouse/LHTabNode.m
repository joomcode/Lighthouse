//
//  LHTabNode.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHTabNode.h"
#import "LHNodeChildrenState.h"
#import "LHTarget.h"

@interface LHTabNode ()

@property (nonatomic, copy, readonly) NSOrderedSet<id<LHNode>> *orderedChildren;

@property (nonatomic, strong) id<LHNodeChildrenState> childrenState;

@end


@implementation LHTabNode

#pragma mark - Init

- (instancetype)initWithChildren:(NSOrderedSet<id<LHNode>> *)children {
    NSParameterAssert(children.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    _orderedChildren = [children copy];
    
    [self resetChildrenState];
    
    return self;
}

#pragma mark - LHNode

@synthesize childrenState = _childrenState;

- (NSSet<id<LHNode>> *)allChildren {
    return [self.orderedChildren set];
}

- (void)resetChildrenState {
    self.childrenState = [[LHNodeChildrenState alloc] initWithInitializedChildren:self.orderedChildren
                                                            activeChildrenIndexSet:[NSIndexSet indexSetWithIndex:0]];
}

- (LHNodeUpdateResult)updateChildrenState:(id<LHTarget>)target {
    if (target.activeNodes.count > 1) {
        return LHNodeUpdateResultInvalid;
    }
    
    if (target.activeNodes.count == 1) {
        NSInteger childIndex = [self.orderedChildren indexOfObject:target.activeNodes.anyObject];
        if (childIndex == NSNotFound) {
            return LHNodeUpdateResultInvalid;
        }
        
        self.childrenState = [[LHNodeChildrenState alloc] initWithInitializedChildren:self.orderedChildren
                                                               activeChildrenIndexSet:[NSIndexSet indexSetWithIndex:childIndex]];
    }
    
    if ([self.childrenState.activeChildren intersectsSet:target.inactiveNodes]) {
        return LHNodeUpdateResultDeactivation;
    }
    
    return LHNodeUpdateResultNormal;
}

@end
