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

@property (nonatomic, strong, readonly) NSSet<id<LHNode>> *activeChildren;

@property (nonatomic, strong, readonly) NSSet<id<LHNode>> *inactiveChildren;

@end


NS_ASSUME_NONNULL_END