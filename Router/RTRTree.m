//
//  RTRTree.m
//  Router
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRTree.h"

@interface RTRTree ()

@property (nonatomic, strong) NSMutableSet *items;
@property (nonatomic, strong) NSMapTable *nextItems;
@property (nonatomic, strong) NSMapTable *previousItems;

@end


@implementation RTRTree

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _items = [[NSMutableSet alloc] init];
    _nextItems = [NSMapTable strongToStrongObjectsMapTable];
    _previousItems = [NSMapTable strongToStrongObjectsMapTable];
    
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    RTRTree *copy = [[[self class] allocWithZone:zone] init];
    
    copy.items = [self.items mutableCopy];
    copy.nextItems = [self.nextItems mutableCopy];
    copy.previousItems = [self.previousItems mutableCopy];
    
    return copy;
}

#pragma mark - Query

- (NSSet *)allItems {
    return self.items;
}

- (id)previousItem:(id)item {
    return [self.previousItems objectForKey:item];
}

- (NSOrderedSet *)nextItems:(id)item {
    return [self.nextItems objectForKey:(item ?: (id)[NSNull null])];
}

- (NSOrderedSet *)pathToItem:(id)item {
    NSMutableOrderedSet *path = [[NSMutableOrderedSet alloc] initWithObject:item];
    
    id currentItem = item;
    
    while (currentItem) {
        [path insertObject:currentItem atIndex:0];
        currentItem = [self previousItem:currentItem];
    }
    
    return [path copy];
}

- (void)enumerateItemsWithBlock:(void (^)(id item, NSInteger depth, BOOL *stop))enumerationBlock {
    [self enumerateItemsRecursivelyWithCurrentItem:nil currentDepth:0 enumerationBlock:enumerationBlock];
}

- (BOOL)enumerateItemsRecursivelyWithCurrentItem:(id)currentItem
                                    currentDepth:(NSInteger)currentDepth
                                enumerationBlock:(void (^)(id item, NSInteger depth, BOOL *stop))enumerationBlock {
    BOOL stop = NO;
    
    for (id childItem in [self nextItems:currentItem]) {
        enumerationBlock(childItem, currentDepth, &stop);
        
        if (stop) {
            break;
        }
        
        stop = [self enumerateItemsRecursivelyWithCurrentItem:childItem
                                                 currentDepth:currentDepth + 1
                                             enumerationBlock:enumerationBlock];
        
        if (stop) {
            break;
        }
    }
    
    return stop;
}

- (void)enumeratePathsToLeavesWithBlock:(void (^)(NSOrderedSet<id> *path, BOOL *stop))enumerationBlock {
    BOOL stop = NO;
    
    for (id item in self.items) {
        if ([self nextItems:item].count == 0) {
            enumerationBlock([self pathToItem:item], &stop);
            
            if (stop) {
                break;
            }
        }
    }
}

#pragma mark - Mutation

- (void)addItem:(id)item afterItemOrNil:(id)previousItem {
    [self.items addObject:item];
    
    if (previousItem) {
        [self.previousItems setObject:previousItem forKey:item];
    }
    
    NSMutableOrderedSet *nextItems = [self.nextItems objectForKey:(previousItem ?: (id)[NSNull null])];
    if (!nextItems) {
        nextItems = [[NSMutableOrderedSet alloc] init];
        [self.nextItems setObject:nextItems forKey:(previousItem ?: (id)[NSNull null])];
    }
    
    [nextItems addObject:item];
}

- (void)addBranch:(NSArray *)items afterItemOrNil:(id)previousItem {
    [items enumerateObjectsUsingBlock:^(id item, NSUInteger idx, BOOL *stop) {
        [self addItem:item afterItemOrNil:(idx == 0 ? previousItem : items[idx - 1])];
    }];
}

- (void)addFork:(NSArray *)items afterItemOrNil:(id)previousItem {
    for (id item in items) {
        [self addItem:item afterItemOrNil:previousItem];
    }
}

@end
