//
//  LHLeafNode.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHLeafNode.h"
#import "LHTarget.h"

@implementation LHLeafNode

#pragma mark - LHNode

- (NSSet<id<LHNode>> *)allChildren {
    return nil;
}

- (id<LHNodeChildrenState>)childrenState {
    return nil;
}

- (void)resetChildrenState {
}

- (LHNodeUpdateResult)updateChildrenState:(LHTarget *)target {
    if (target.activeNodes.count > 0 || target.inactiveNodes.count > 0) {
        return LHNodeUpdateResultInvalid;
    }
    
    return LHNodeUpdateResultNormal;
}

@end
