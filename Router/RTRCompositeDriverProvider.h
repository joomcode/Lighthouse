//
//  RTRCompositeDriverProvider.h
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriverProvider.h"

@interface RTRCompositeDriverProvider : NSObject <RTRDriverProvider>

- (instancetype)initWithDriverProviders:(NSArray *)driverProviders;

@end
