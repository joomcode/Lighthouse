//
//  LHDescriptionHelpers.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodeState.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LHNode;


@interface LHDescriptionHelpers : NSObject

+ (NSString *)stringFromNodeState:(LHNodeState)state;

+ (NSString *)descriptionForNodePath:(NSArray<id<LHNode>> *)path;

@end

NS_ASSUME_NONNULL_END



