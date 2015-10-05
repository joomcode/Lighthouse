//
//  RTRLeafNode.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRLeafNode.h"

@implementation RTRLeafNode

#pragma mark - RTRNode

- (NSSet *)allChildren {
    return nil;
}

- (id<RTRNodeChildrenState>)childrenState {
    return nil;
}

- (void)resetChildrenState {
}

- (BOOL)updateChildrenState:(RTRTarget *)target {
    return NO;
}

@end
