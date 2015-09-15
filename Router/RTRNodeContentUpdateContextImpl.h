//
//  RTRNodeContentUpdateContextImpl.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentUpdateContext.h"

@interface RTRNodeContentUpdateContextImpl : NSObject <RTRNodeContentUpdateContext>

@property (nonatomic, getter = isAnimated) BOOL animated;

@property (nonatomic, strong) id<RTRNodeChildrenState> childrenState;

@property (nonatomic, copy) id<RTRNodeContent> (^contentBlock)(id<RTRNode> node);

@end
