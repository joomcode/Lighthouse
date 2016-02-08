//
//  LHCompositeDriverFactory.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriverFactory.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHCompositeDriverFactory : NSObject <LHDriverFactory>

- (instancetype)initWithDriverFactories:(NSArray<id<LHDriverFactory>> *)driverFactories NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END