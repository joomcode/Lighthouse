//
//  RTRNodeData.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTRNodeState.h"

@protocol RTRNode;
@protocol RTRNodeContent;

@interface RTRNodeData : NSObject

@property (nonatomic, readonly) id<RTRNode> node;

@property (nonatomic, assign) RTRNodeState state;

@property (nonatomic, assign) RTRNodeState presentationState;

@property (nonatomic, strong) id<RTRNodeContent> content;

- (instancetype)initWithNode:(id<RTRNode>)node;

@end