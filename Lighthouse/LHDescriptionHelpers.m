//
//  LHDescriptionHelpers.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHDescriptionHelpers.h"
#import "LHNode.h"

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

+ (NSString *)descriptionForNodePath:(NSOrderedSet<id<LHNode>> *)path {
    NSMutableString *description = [NSMutableString string];
    for (id<LHNode> node in path) {
        if (description.length > 0) {
            [description appendString:@" -> "];
        }
        [description appendString:node.label ?: @"(unnamed)"];
    }
    return [description copy];
}

@end
