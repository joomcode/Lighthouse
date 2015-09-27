//
//  RTRTree.h
//  Router
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTRTree<ObjectType> : NSObject <NSCopying>

- (NSSet<ObjectType> *)allItems;

- (ObjectType)previousItem:(ObjectType)item;
- (NSOrderedSet<ObjectType> *)nextItems:(ObjectType)item;

- (NSOrderedSet<ObjectType> *)pathToItem:(ObjectType)item;

- (void)enumerateItemsWithBlock:(void (^)(ObjectType item, ObjectType previousItem, BOOL *stop))enumerationBlock;
- (void)enumeratePathsToLeavesWithBlock:(void (^)(NSOrderedSet<ObjectType> *path, BOOL *stop))enumerationBlock;

@end


// TODO: split into mutable subclass?

@interface RTRTree<ObjectType> (Mutation)

- (void)addItem:(ObjectType)item afterItemOrNil:(ObjectType)previousItem;

- (void)addBranch:(NSArray<ObjectType> *)item afterItemOrNil:(ObjectType)previousItem;

- (void)addFork:(NSArray<ObjectType> *)item afterItemOrNil:(ObjectType)previousItem;

@end
