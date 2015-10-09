//
//  RTRCompositeDriver.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRCompositeDriver.h"
#import "RTRDriverUpdateContextImpl.h"

@interface RTRCompositeDriver ()

@property (nonatomic, copy, readonly) NSDictionary *driversById;
@property (nonatomic, assign, readonly) BOOL hasFeedbackChannel;

@end


@implementation RTRCompositeDriver

#pragma mark - Init

- (instancetype)init {
    return [self initWithDriversById:nil];
}

- (instancetype)initWithDriversById:(NSDictionary *)driversById {
    NSParameterAssert(driversById != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _driversById = [driversById copy];
    
    for (id<RTRDriver> driver in driversById.allValues) {
        if ([driver respondsToSelector:@selector(setFeedbackChannel:)]) {
            _hasFeedbackChannel = YES;
            break;
        }
    }
    
    return self;
}

#pragma mark - RTRDriver

@dynamic data;
@synthesize feedbackChannel = _feedbackChannel;

- (id)data {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:self.driversById.count];
    
    [self.driversById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> driverId, id<RTRDriver> driver, BOOL *stop) {
        if (driver.data) {
            data[driverId] = driver.data;
        }
    }];
    
    return data;
}

- (void)updateWithContext:(id<RTRDriverUpdateContext>)context {
    [self.driversById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> driverId, id<RTRDriver> driver, BOOL *stop) {
        [driver updateWithContext:
            [[RTRDriverUpdateContextImpl alloc] initWithAnimated:context.animated
                                                         command:context.command
                                                     updateQueue:context.updateQueue
                                                   childrenState:context.childrenState
                                                     driverBlock:^id<RTRDriver>(id<RTRNode> node) {                                                         
                                                         return ((RTRCompositeDriver *)[context driverForNode:node]).driversById[driverId];
                                                     }]];
    }];
}

- (void)stateDidChange:(RTRNodeState)state {
    [self.driversById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> driverId, id<RTRDriver> driver, BOOL *stop) {
        if ([driver respondsToSelector:@selector(stateDidChange:)]) {
            [driver stateDidChange:state];
        }
    }];
}

- (void)setFeedbackChannel:(id<RTRDriverFeedbackChannel>)feedbackChannel {
    _feedbackChannel = feedbackChannel;
    
    for (id<RTRDriver> driver in self.driversById.allValues) {
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
