//
//  LHNode.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNodeChildrenState;
@protocol LHTarget;

NS_ASSUME_NONNULL_BEGIN


@protocol LHNode <NSObject>

@property (nonatomic, strong, readonly, nullable) NSSet<id<LHNode>> *allChildren;

@property (nonatomic, strong, readonly, nullable) id<LHNodeChildrenState> childrenState;

- (void)resetChildrenState;

- (BOOL)updateChildrenState:(id<LHTarget>)target;

@end


NS_ASSUME_NONNULL_END