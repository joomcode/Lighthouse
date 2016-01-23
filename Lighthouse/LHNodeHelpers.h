//
//  LHNodeHelpers.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 23/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNode;
@protocol LHTarget;

NS_ASSUME_NONNULL_BEGIN


@interface LHNodeHelpers : NSObject

+ (nullable id<LHNode>)activeChildForApplyingTarget:(id<LHTarget>)target
                                      toActiveStack:(NSOrderedSet<id<LHNode>> *)activeStack
                                              error:(BOOL *)error;

@end


NS_ASSUME_NONNULL_END