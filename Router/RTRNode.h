//
//  RTRNode.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNodeChildrenState;
@protocol RTRTarget;

NS_ASSUME_NONNULL_BEGIN


@protocol RTRNode <NSObject>

@property (nonatomic, strong, readonly, nullable) NSSet<id<RTRNode>> *allChildren;

@property (nonatomic, strong, readonly, nullable) id<RTRNodeChildrenState> childrenState;

- (void)resetChildrenState;

- (BOOL)updateChildrenState:(id<RTRTarget>)target;

@end


NS_ASSUME_NONNULL_END