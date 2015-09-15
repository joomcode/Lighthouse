//
//  RTRNodeState.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RTRNodeState) {
    RTRNodeStateInactive = 0,
    RTRNodeStateInitialized = 1,
    RTRNodeStateActive = 2
};