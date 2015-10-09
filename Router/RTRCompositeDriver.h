//
//  RTRCompositeDriver.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriver.h"

@interface RTRCompositeDriver : NSObject <RTRDriver>

- (instancetype)initWithDriversById:(NSDictionary *)driversById;

@end
