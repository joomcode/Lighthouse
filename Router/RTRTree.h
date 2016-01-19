//
//  RTRTree.h
//  Router
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface RTRTree<ObjectType> : NSObject <NSCopying>

- (NSSet<ObjectType> *)allItems;

- (nullable ObjectType)previousItem:(ObjectType)item;
- (nullable NSOrderedSet<ObjectType> *)nextItems:(nullable ObjectType)item;

- (nullable NSOrderedSet<ObjectType> *)pathToItem:(ObjectType)item;

- (void)enumerateItemsWithBlock:(void (^)(ObjectType item, ObjectType _Nullable previousItem, BOOL *stop))enumerationBlock;
- (void)enumeratePathsToLeavesWithBlock:(void (^)(NSOrderedSet<ObjectType> *path, BOOL *stop))enumerationBlock;

@end


// TODO: split into mutable subclass?

@interface RTRTree<ObjectType> (Mutation)

- (void)addItem:(ObjectType)item afterItemOrNil:(nullable ObjectType)previousItem;

- (void)addBranch:(NSArray<ObjectType> *)item afterItemOrNil:(nullable ObjectType)previousItem;

- (void)addFork:(NSArray<ObjectType> *)item afterItemOrNil:(nullable ObjectType)previousItem;

@end


NS_ASSUME_NONNULL_END