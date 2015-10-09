//
//  RTRTarget.h
//  Router
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;

@protocol RTRTarget <NSObject>

@property (nonatomic, copy, readonly) NSSet *activeNodes;

@property (nonatomic, copy, readonly) NSSet *inactiveNodes;

@end


@interface RTRTarget : NSObject <RTRTarget>

- (instancetype)initWithActiveNodes:(NSSet *)activeNodes inactiveNodes:(NSSet *)inactiveNodes;

+ (instancetype)withActiveNode:(id<RTRNode>)activeNode;

+ (instancetype)withActiveNodes:(NSArray *)activeNodes;

+ (instancetype)withInactiveNode:(id<RTRNode>)inactiveNode;

+ (instancetype)withInactiveNodes:(NSArray *)inactiveNodes;

@end