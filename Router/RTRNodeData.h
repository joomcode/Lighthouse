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
@protocol RTRDriver;

NS_ASSUME_NONNULL_BEGIN


@interface RTRNodeData : NSObject

@property (nonatomic, strong, readonly) id<RTRNode> node;

@property (nonatomic, assign) RTRNodeState state;

@property (nonatomic, assign) RTRNodeState presentationState;

@property (nonatomic, strong, nullable) id<RTRDriver> driver;

- (instancetype)initWithNode:(id<RTRNode>)node NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END