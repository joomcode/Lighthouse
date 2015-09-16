//
//  RTRNodeContentUpdateContextImpl.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentUpdateContext.h"

@interface RTRNodeContentUpdateContextImpl : NSObject <RTRNodeContentUpdateContext>

- (instancetype)initWithAnimated:(BOOL)animated
                   childrenState:(id<RTRNodeChildrenState>)childrenState
                    contentBlock:(id<RTRNodeContent> (^)(id<RTRNode> node))contentBlock;

@end
