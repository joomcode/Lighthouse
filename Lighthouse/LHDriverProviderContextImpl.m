//
//  LHDriverProviderContextImpl.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 21/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHDriverProviderContextImpl.h"

@implementation LHDriverProviderContextImpl

#pragma mark - Init

- (instancetype)initWithChannel:(id<LHDriverChannel>)channel {
    self = [super init];
    if (!self) return nil;
    
    _channel = channel;
    
    return self;
}

#pragma mark - LHDriverProviderContext

@synthesize channel = _channel;

@end
