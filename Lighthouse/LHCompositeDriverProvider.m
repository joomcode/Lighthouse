//
//  LHCompositeDriverProvider.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHCompositeDriverProvider.h"
#import "LHCompositeDriver.h"

@interface LHCompositeDriverProvider ()

@property (nonatomic, copy, readonly) NSDictionary<id<NSCopying>, id<LHDriverProvider>> *driverProvidersById;

@end


@implementation LHCompositeDriverProvider

#pragma mark - Init

- (instancetype)initWithDriverProviders:(NSArray<id<LHDriverProvider>> *)driverProviders {
    NSParameterAssert(driverProviders.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    NSMutableDictionary<id<NSCopying>, id<LHDriverProvider>> *driverProvidersById = [[NSMutableDictionary alloc] initWithCapacity:driverProviders.count];
    [driverProviders enumerateObjectsUsingBlock:^(id<LHDriverProvider> obj, NSUInteger idx, BOOL *stop) {
        driverProvidersById[[@(idx) stringValue]] = obj;
    }];
    _driverProvidersById = [driverProvidersById copy];
    
    return self;
}

#pragma mark - LHDriverProvider

- (id<LHDriver>)driverForNode:(id<LHNode>)node {
    NSMutableDictionary<id<NSCopying>, id<LHDriver>> *driversById = [[NSMutableDictionary alloc] initWithCapacity:self.driverProvidersById.count];
    
    [self.driverProvidersById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> providerId, id<LHDriverProvider> provider, BOOL *stop) {
        id<LHDriver> driver = [provider driverForNode:node];
        if (driver) {
            driversById[providerId] = driver;
        }
    }];
    
    return [[LHCompositeDriver alloc] initWithDriversById:driversById];
}

@end
