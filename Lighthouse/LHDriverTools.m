//
//  LHDriverTools.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 08/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHDriverTools.h"

@implementation LHDriverTools

- (instancetype)initWithProvider:(id<LHDriverProvider>)provider
                         channel:(id<LHDriverChannel>)channel {
    self = [super init];
    if (!self) return nil;
    
    _provider = provider;
    _channel = channel;
    
    return self;
}

@end
