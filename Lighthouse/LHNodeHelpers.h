//
//  LHNodeHelpers.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 28/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN


@interface LHNodeHelpers : NSObject

+ (NSSet<id<LHNode>> *)allDescendantsOfNode:(id<LHNode>)node;

@end


NS_ASSUME_NONNULL_END