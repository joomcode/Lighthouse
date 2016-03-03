//
//  LHDescriptionHelpers.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHDescriptionHelpers.h"

@implementation LHDescriptionHelpers

+ (NSString *)stringFromNodeState:(LHNodeState)state {
    switch (state) {
        case LHNodeStateNotInitialized:
            return @"not initialized";
        case LHNodeStateInactive:
            return @"inactive";
        case LHNodeStateDeactivating:
            return @"deactivating";
        case LHNodeStateActivating:
            return @"activating";
        case LHNodeStateActive:
            return @"active";
    }
}

@end
