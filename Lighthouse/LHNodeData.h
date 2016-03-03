//
//  LHNodeData.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodeState.h"

@protocol LHNode;
@protocol LHDriver;

NS_ASSUME_NONNULL_BEGIN


@interface LHNodeData : NSObject

@property (nonatomic, strong, readonly) id<LHNode> node;

@property (nonatomic, assign) LHNodeState state;

@property (nonatomic, strong, nullable) id<LHDriver> driver;

- (instancetype)initWithNode:(id<LHNode>)node NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END