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
@property (nonatomic, assign, readonly) BOOL hasFeedbackChannel;

@end


@implementation LHCompositeDriver

#pragma mark - Init

- (instancetype)initWithDriversById:(NSDictionary<id<NSCopying>, id<LHDriver>> *)driversById {
    self = [super init];
    if (!self) return nil;
    
    _driversById = [driversById copy];
    
    for (id<LHDriver> driver in driversById.allValues) {
        if ([driver respondsToSelector:@selector(setFeedbackChannel:)]) {
            _hasFeedbackChannel = YES;
            break;
        }
    }
    
    return self;
}

#pragma mark - LHDriver

@dynamic data;
@synthesize feedbackChannel = _feedbackChannel;

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

- (void)stateDidChange:(LHNodePresentationState)state {
    [self.driversById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> driverId, id<LHDriver> driver, BOOL *stop) {
        if ([driver respondsToSelector:@selector(stateDidChange:)]) {
            [driver stateDidChange:state];
        }
    }];
}

- (void)setFeedbackChannel:(id<LHDriverFeedbackChannel>)feedbackChannel {
    _feedbackChannel = feedbackChannel;
    
    for (id<LHDriver> driver in self.driversById.allValues) {
        if ([driver respondsToSelector:@selector(setFeedbackChannel:)]) {
            driver.feedbackChannel = feedbackChannel;
        }
    }
}

#pragma mark - NSObject trickery

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (!self.hasFeedbackChannel &&
        (aSelector == @selector(feedbackChannel) || aSelector == @selector(setFeedbackChannel:)))
    {
        return NO;
    }
    
    return [super respondsToSelector:aSelector];
}

@end
