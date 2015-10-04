//
//  RTRTargetNodes.h
//  Router
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;

@interface RTRTargetNodes : NSObject

@property (nonatomic, copy, readonly) NSSet *activeNodes;
@property (nonatomic, copy, readonly) NSSet *inactiveNodes;

- (instancetype)initWithActiveNodes:(NSSet *)activeNodes inactiveNodes:(NSSet *)inactiveNodes;

@end


@interface RTRTargetNodes (Convenience)

+ (instancetype)withActiveNode:(id<RTRNode>)activeNode;

+ (instancetype)withActiveNodes:(NSArray *)activeNodes;

+ (instancetype)withInactiveNode:(id<RTRNode>)inactiveNode;

+ (instancetype)withInactiveNodes:(NSArray *)inactiveNodes;

@end