//
//  RTRNodeChildrenState.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;

NS_ASSUME_NONNULL_BEGIN


@protocol RTRNodeChildrenState <NSObject>

@property (nonatomic, strong, readonly) NSOrderedSet<id<RTRNode>> *initializedChildren;

@property (nonatomic, strong, readonly) NSSet<id<RTRNode>> *activeChildren;

@end


@interface RTRNodeChildrenState : NSObject <RTRNodeChildrenState>

- (instancetype)initWithInitializedChildren:(nullable NSOrderedSet<id<RTRNode>> *)initializedChildren
                     activeChildrenIndexSet:(nullable NSIndexSet *)activeChildrenIndexSet NS_DESIGNATED_INITIALIZER;

@end


NS_ASSUME_NONNULL_END