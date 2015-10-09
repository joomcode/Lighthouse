//
//  RTRNodeState.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RTRNodeState) {
    RTRNodeStateNotInitialized = 0,
    RTRNodeStateInactive = 1,
    RTRNodeStateDeactivating = 2,
    RTRNodeStateActivating = 3,
    RTRNodeStateActive = 4
};


static inline BOOL RTRNodeStateIsInitialized(RTRNodeState state) {
    return state != RTRNodeStateNotInitialized;
}

static inline BOOL RTRNodeStateIsTransitioning(RTRNodeState state) {
    return state == RTRNodeStateDeactivating || state == RTRNodeStateActivating;
}