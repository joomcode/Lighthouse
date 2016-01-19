//
//  RTRTarget.h
//  Router
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;

NS_ASSUME_NONNULL_BEGIN


@protocol RTRTarget <NSObject>

@property (nonatomic, copy, readonly) NSSet<id<RTRNode>> *activeNodes;

@property (nonatomic, copy, readonly) NSSet<id<RTRNode>> *inactiveNodes;

@end


@interface RTRTarget : NSObject <RTRTarget>

- (instancetype)initWithActiveNodes:(nullable NSSet<id<RTRNode>> *)activeNodes
                      inactiveNodes:(nullable NSSet<id<RTRNode>> *)inactiveNodes NS_DESIGNATED_INITIALIZER;

+ (instancetype)withActiveNode:(id<RTRNode>)activeNode;

+ (instancetype)withActiveNodes:(NSArray<id<RTRNode>> *)activeNodes;

+ (instancetype)withInactiveNode:(id<RTRNode>)inactiveNode;

+ (instancetype)withInactiveNodes:(NSArray<id<RTRNode>> *)inactiveNodes;

@end


NS_ASSUME_NONNULL_END