//
//  LHNodeChildrenState.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN


@protocol LHNodeChildrenState <NSObject>

@property (nonatomic, strong, readonly) NSOrderedSet<id<LHNode>> *initializedChildren;

@property (nonatomic, strong, readonly) NSSet<id<LHNode>> *activeChildren;

@end


@interface LHNodeChildrenState : NSObject <LHNodeChildrenState>

- (instancetype)initWithInitializedChildren:(nullable NSOrderedSet<id<LHNode>> *)initializedChildren
                     activeChildrenIndexSet:(nullable NSIndexSet *)activeChildrenIndexSet NS_DESIGNATED_INITIALIZER;

@end


NS_ASSUME_NONNULL_END