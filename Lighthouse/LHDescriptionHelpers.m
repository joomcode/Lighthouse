//
//  LHDescriptionHelpers.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHDescriptionHelpers.h"

NSString *LHStringFromNodeState(LHNodeState state) {
    switch (state) {
        case LHNodeStateNotInitialized:
            return @"not initialized";
        case LHNodeStateInactive:
            return @"inactive";
        case LHNodeStateActive:
            return @"active";
    }
}

NSString *LHStringFromNodePresentationState(LHNodePresentationState state) {
    switch (state) {
        case LHNodePresentationStateNotInitialized:
            return @"not initialized";
        case LHNodePresentationStateInactive:
            return @"inactive";
        case LHNodePresentationStateDeactivating:
            return @"deactivating";
        case LHNodePresentationStateActivating:
            return @"activating";
        case LHNodePresentationStateActive:
            return @"active";
    }
}