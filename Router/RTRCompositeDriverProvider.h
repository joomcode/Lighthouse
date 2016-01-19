//
//  RTRCompositeDriverProvider.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriverProvider.h"

NS_ASSUME_NONNULL_BEGIN


@interface RTRCompositeDriverProvider : NSObject <RTRDriverProvider>

- (instancetype)initWithDriverProviders:(NSArray<id<RTRDriverProvider>> *)driverProviders NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END