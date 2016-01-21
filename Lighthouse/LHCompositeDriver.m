//
//  LHCompositeDriver.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHCompositeDriver.h"
#import "LHDriverUpdateContextImpl.h"

@interface LHCompositeDriver ()

@property (nonatomic, copy, readonly) NSDictionary<id<NSCopying>, id<LHDriver>> *driversById;

@end


@implementation LHCompositeDriver

#pragma mark - Init

- (instancetype)initWithDriversById:(NSDictionary<id<NSCopying>, id<LHDriver>> *)driversById {
    self = [super init];
    if (!self) return nil;
    
    _driversById = [driversById copy];
    
    return self;
}

#pragma mark - LHDriver

@dynamic data;

- (id)data {
    NSMutableDictionary<id<NSCopying>, id> *data = [[NSMutableDictionary alloc] initWithCapacity:self.driversById.count];
    
    [self.driversById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> driverId, id<LHDriver> driver, BOOL *stop) {
        if (driver.data) {
            data[driverId] = driver.data;
        }
    }];
    
    return data;
}

- (void)updateWithContext:(id<LHDriverUpdateContext>)context {
    [self.driversById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> driverId, id<LHDriver> driver, BOOL *stop) {
        [driver updateWithContext:
            [[LHDriverUpdateContextImpl alloc] initWithAnimated:context.animated
                                                         command:context.command
                                                   childrenState:context.childrenState
                                                     updateQueue:context.updateQueue
                                                     driverBlock:^id<LHDriver>(id<LHNode> node) {
                                                         return ((LHCompositeDriver *)[context driverForNode:node]).driversById[driverId];
                                                     }]];
    }];
}

- (void)presentationStateDidChange:(LHNodePresentationState)presentationState {
    [self.driversById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> driverId, id<LHDriver> driver, BOOL *stop) {
        [driver presentationStateDidChange:presentationState];
    }];
}

@end
