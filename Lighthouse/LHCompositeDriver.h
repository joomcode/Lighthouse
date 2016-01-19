//
//  LHCompositeDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriver.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHCompositeDriver : NSObject <LHDriver>

- (instancetype)initWithDriversById:(NSDictionary<id<NSCopying>, id<LHDriver>> *)driversById NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END