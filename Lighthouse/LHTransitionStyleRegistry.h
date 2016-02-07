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

- (void)registerTransitionStyle:(StyleType)transitionStyle
                  forSourceNode:(nullable id<LHNode>)sourceNode
                destinationNode:(nullable id<LHNode>)destinationNode;

- (void)registerDefaultTransitionStyle:(StyleType)transitionStyle;

- (nullable StyleType)transitionStyleForSourceNode:(id<LHNode>)sourceNode destinationNode:(id<LHNode>)destinationNode;

@end


NS_ASSUME_NONNULL_END