//
//  NSMapTable+LHUtils.m
//  Lighthouse
//
//  Created by Makarov Yury on 05/11/2016.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "NSMapTable+LHUtils.h"

@implementation NSMapTable (LHUtils)

- (NSArray *)allKeys {
    NSMutableArray *allKeys = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (id key in self) {
        [allKeys addObject:key];
    }
    return allKeys;
}

- (NSArray *)allObjects {
    NSMutableArray *allObjects = [NSMutableArray array];
    for (id key in self.allKeys) {
        [allObjects addObject:[self objectForKey:key]];
    }
    return [allObjects copy];
}

- (id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id)key {
    [self setObject:object forKey:key];
}

- (BOOL)containsObject:(id)object {
    return [self.allObjects containsObject:object];
}

- (id)keyForObject:(id)object {
    for (id key in self) {
        if ([self[key] isEqual:object]) {
            return key;
        }
    }
    return nil;
}

@end
