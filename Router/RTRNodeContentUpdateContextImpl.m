//
//  RTRNodeContentUpdateContextImpl.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentUpdateContextImpl.h"

@implementation RTRNodeContentUpdateContextImpl

- (id<RTRNodeContent>)contentForNode:(id<RTRNode>)node {
    return self.contentBlock(node);
}

@end
