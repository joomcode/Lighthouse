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
    RTRNodeStateActive = 2
};