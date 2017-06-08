//
//  LHTransitionStyleRegistry.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 06/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN


@interface LHTransitionStyleRegistry<StyleType> : NSObject

- (void)registerTransitionStyle:(nullable StyleType)transitionStyle
                  forSourceNode:(nullable id<LHNode>)sourceNode
                destinationNode:(nullable id<LHNode>)destinationNode;

- (void)registerDefaultTransitionStyle:(StyleType)transitionStyle;

@end


@interface LHTransitionStyleEntry<StyleType> : NSObject

@property (nonatomic, strong, readonly) StyleType transitionStyle;

@property (nonatomic, strong, readonly, nullable) id<LHNode> sourceNode;
@property (nonatomic, strong, readonly, nullable) id<LHNode> destinationNode;

@end


@interface LHTransitionStyleRegistry<StyleType> (Query)

- (nullable LHTransitionStyleEntry<StyleType> *)entryForSourceNodes:(NSSet<id<LHNode>> *)sourceNodes
                                                   destinationNodes:(NSSet<id<LHNode>> *)destinationNodes;

@end


NS_ASSUME_NONNULL_END