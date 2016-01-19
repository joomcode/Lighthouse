//
//  LHCompositeDriverProvider.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriverProvider.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHCompositeDriverProvider : NSObject <LHDriverProvider>

- (instancetype)initWithDriverProviders:(NSArray<id<LHDriverProvider>> *)driverProviders NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END