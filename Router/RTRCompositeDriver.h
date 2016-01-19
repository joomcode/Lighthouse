//
//  RTRCompositeDriver.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriver.h"

NS_ASSUME_NONNULL_BEGIN


@interface RTRCompositeDriver : NSObject <RTRDriver>

- (instancetype)initWithDriversById:(NSDictionary<id<NSCopying>, id<RTRDriver>> *)driversById NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END