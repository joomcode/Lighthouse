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

@protocol RTRNode <NSObject>

@property (nonatomic, readonly) NSSet *allChildren;

@property (nonatomic, readonly) id<RTRNodeChildrenState> childrenState;

- (void)resetChildrenState;

- (BOOL)updateChildrenState:(id<RTRTarget>)target;

@end