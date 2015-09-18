//
//  RTRDescriptionHelpers.m
//  Router
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRDescriptionHelpers.h"

NSString *RTRStringFromNodeState(RTRNodeState nodeState) {
    switch (nodeState) {
        case RTRNodeStateNotInitialized:
            return @"not initialized";
        case RTRNodeStateInactive:
            return @"inactive";
        case RTRNodeStateDeactivating:
            return @"deactivating";
        case RTRNodeStateActivating:
            return @"activating";
        case RTRNodeStateActive:
            return @"active";
    }
}