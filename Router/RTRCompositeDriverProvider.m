//
//  RTRCompositeDriverProvider.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRCompositeDriverProvider.h"
#import "RTRCompositeDriver.h"

@interface RTRCompositeDriverProvider ()

@property (nonatomic, copy, readonly) NSDictionary *driverProvidersById;

@end


@implementation RTRCompositeDriverProvider

#pragma mark - Init

- (instancetype)init {
    return [self initWithDriverProviders:nil];
}

- (instancetype)initWithDriverProviders:(NSArray *)driverProviders {
    NSParameterAssert(driverProviders.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    NSMutableDictionary *driverProvidersById = [[NSMutableDictionary alloc] initWithCapacity:driverProviders.count];
    [driverProviders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        driverProvidersById[[@(idx) stringValue]] = obj;
    }];
    
    _driverProvidersById = [driverProvidersById copy];
    
    return self;
}

#pragma mark - RTRDriverProvider

- (id<RTRDriver>)driverForNode:(id<RTRNode>)node {
    NSMutableDictionary *driversById = [[NSMutableDictionary alloc] initWithCapacity:self.driverProvidersById.count];
    
    [self.driverProvidersById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> providerId, id<RTRDriverProvider> provider, BOOL *stop) {
        id<RTRDriver> driver = [provider driverForNode:node];
        if (driver) {
            driversById[providerId] = driver;
        }
    }];
    
    return [[RTRCompositeDriver alloc] initWithDriversById:driversById];
}

@end