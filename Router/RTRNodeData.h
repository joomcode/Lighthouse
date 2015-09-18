//
//  RTRNodeData.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTRNodeState.h"
#import "RTRNodeContentState.h"

@protocol RTRNodeChildrenState;
@protocol RTRNodeContent;

@interface RTRNodeData : NSObject

@property (nonatomic, assign) RTRNodeState state;

@property (nonatomic, strong) id<RTRNodeChildrenState> childrenState;

@property (nonatomic, strong) id<RTRNodeContent> content;

@property (nonatomic, assign) RTRNodeContentState contentState;

@end
