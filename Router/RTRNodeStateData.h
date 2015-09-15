//
//  RTRNodeStateData.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTRNodeState.h"

@protocol RTRNodeChildrenState;

@interface RTRNodeStateData : NSObject

@property (nonatomic, assign) RTRNodeState state;

@property (nonatomic, strong) id<RTRNodeChildrenState> childrenState;

@property (nonatomic, copy) NSMapTable *contentByProvider;

@end
