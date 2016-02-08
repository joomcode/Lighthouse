//
//  LHCompositeDriverFactory.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHCompositeDriverFactory.h"
#import "LHCompositeDriver.h"

@interface LHCompositeDriverFactory ()

@property (nonatomic, copy, readonly) NSDictionary<id<NSCopying>, id<LHDriverFactory>> *driverFactoriesById;

@end


@implementation LHCompositeDriverFactory

#pragma mark - Init

- (instancetype)initWithDriverFactories:(NSArray<id<LHDriverFactory>> *)driverFactories {
    NSParameterAssert(driverFactories.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    NSMutableDictionary<id<NSCopying>, id<LHDriverFactory>> *driverFactoriesById = [[NSMutableDictionary alloc] initWithCapacity:driverFactories.count];
    [driverFactories enumerateObjectsUsingBlock:^(id<LHDriverFactory> obj, NSUInteger idx, BOOL *stop) {
        driverFactoriesById[[@(idx) stringValue]] = obj;
    }];
    _driverFactoriesById = [driverFactoriesById copy];
    
    return self;
}

#pragma mark - LHDriverFactory

- (id<LHDriver>)driverForNode:(id<LHNode>)node withTools:(LHDriverTools *)tools {
    NSMutableDictionary<id<NSCopying>, id<LHDriver>> *driversById = [[NSMutableDictionary alloc] initWithCapacity:self.driverFactoriesById.count];
    
    [self.driverFactoriesById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> factoryId, id<LHDriverFactory> factory, BOOL *stop) {
        id<LHDriver> driver = [factory driverForNode:node withTools:tools];
        if (driver) {
            driversById[factoryId] = driver;
        }
    }];
    
    return [[LHCompositeDriver alloc] initWithDriversById:driversById];
}

@end
