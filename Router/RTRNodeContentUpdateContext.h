//
//  RTRNodeContentUpdateContext.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;
@protocol RTRNodeContent;
@protocol RTRNodeChildrenState;

@protocol RTRNodeContentUpdateContext <NSObject>

@property (nonatomic, readonly, getter = isAnimated) BOOL animated;

@property (nonatomic, readonly) id<RTRNodeChildrenState> childrenState;

- (id<RTRNodeContent>)contentForChildNode:(id<RTRNode>)childNode;

@end
