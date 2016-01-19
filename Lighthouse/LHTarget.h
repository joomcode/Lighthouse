//
//  LHTarget.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN


@protocol LHTarget <NSObject>

@property (nonatomic, copy, readonly) NSSet<id<LHNode>> *activeNodes;

@property (nonatomic, copy, readonly) NSSet<id<LHNode>> *inactiveNodes;

@end


@interface LHTarget : NSObject <LHTarget>

- (instancetype)initWithActiveNodes:(nullable NSSet<id<LHNode>> *)activeNodes
                      inactiveNodes:(nullable NSSet<id<LHNode>> *)inactiveNodes NS_DESIGNATED_INITIALIZER;

+ (instancetype)withActiveNode:(id<LHNode>)activeNode;

+ (instancetype)withActiveNodes:(NSArray<id<LHNode>> *)activeNodes;

+ (instancetype)withInactiveNode:(id<LHNode>)inactiveNode;

+ (instancetype)withInactiveNodes:(NSArray<id<LHNode>> *)inactiveNodes;

@end


NS_ASSUME_NONNULL_END