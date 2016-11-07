//
//  NSMapTable+LHUtils.m
//  Lighthouse
//
//  Created by Makarov Yury on 05/11/2016.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "NSMapTable+LHUtils.h"

@implementation NSMapTable (LHUtils)

- (NSArray *)lh_allKeys {
    NSMutableArray *allKeys = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (id key in self) {
        [allKeys addObject:key];
    }
    return allKeys;
}

- (NSArray *)lh_allObjects {
    NSMutableArray *allObjects = [NSMutableArray array];
    for (id key in self.lh_allKeys) {
        [allObjects addObject:[self objectForKey:key]];
    }
    return [allObjects copy];
}

- (BOOL)containsObject:(id)object {
    return [self.lh_allObjects containsObject:object];
}

- (id)lh_keyForObject:(id)object {
    for (id key in self) {
        if ([[self objectForKey:key] isEqual:object]) {
            return key;
        }
    }
    return nil;
}

@end
