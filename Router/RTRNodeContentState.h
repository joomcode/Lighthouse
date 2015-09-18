//
//  RTRNodeContentState.h
//  Router
//
//  Created by Nick Tymchenko on 18/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RTRNodeContentState) {
    RTRNodeContentStateNotInitialized = 0,
    RTRNodeContentStateInactive = 1,
    RTRNodeContentStateActivating = 2,
    RTRNodeContentStateDeactivating = 3,
    RTRNodeContentStateActive = 4
};