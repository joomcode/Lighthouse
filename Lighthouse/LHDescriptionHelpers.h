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


@interface LHDescriptionHelpers : NSObject

+ (NSString *)stringFromNodeState:(LHNodeState)state;

@end


NS_ASSUME_NONNULL_END



