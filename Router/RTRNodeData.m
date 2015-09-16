//
//  RTRNodeData.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeData.h"
#import "RTRNodeChildrenState.h"

@implementation RTRNodeData

- (id<RTRNodeChildrenState>)childrenState {
    if (!_childrenState) {
        _childrenState = [[RTRNodeChildrenState alloc] init];
    }
    return _childrenState;
}

@end
