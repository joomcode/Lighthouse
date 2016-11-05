//
//  LHTarget.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHDebugPrintable.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LHNode;
@class LHRouteHint;


@interface LHTarget : NSObject <LHDebugPrintable>

@property (nonatomic, copy, readonly) NSSet<id<LHNode>> *activeNodes;
@property (nonatomic, copy, readonly) NSSet<id<LHNode>> *inactiveNodes;
@property (nonatomic, strong, readonly, nullable) LHRouteHint *routeHint;

- (instancetype)initWithActiveNodes:(nullable NSSet<id<LHNode>> *)activeNodes
                      inactiveNodes:(nullable NSSet<id<LHNode>> *)inactiveNodes
                          routeHint:(nullable LHRouteHint *)hint NS_DESIGNATED_INITIALIZER;

+ (instancetype)withActiveNode:(id<LHNode>)activeNode routeHint:(nullable LHRouteHint *)hint;
+ (instancetype)withActiveNode:(id<LHNode>)activeNode;

+ (instancetype)withActiveNodes:(NSArray<id<LHNode>> *)activeNodes routeHint:(nullable LHRouteHint *)hint;
+ (instancetype)withActiveNodes:(NSArray<id<LHNode>> *)activeNodes;

+ (instancetype)withInactiveNode:(id<LHNode>)inactiveNode routeHint:(nullable LHRouteHint *)hint;
+ (instancetype)withInactiveNode:(id<LHNode>)inactiveNode;

+ (instancetype)withInactiveNodes:(NSArray<id<LHNode>> *)inactiveNodes routeHint:(nullable LHRouteHint *)hint;
+ (instancetype)withInactiveNodes:(NSArray<id<LHNode>> *)inactiveNodes;

@end


NS_ASSUME_NONNULL_END
