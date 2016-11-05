//
//  NSMapTable+LHUtils.h
//  Lighthouse
//
//  Created by Makarov Yury on 05/11/2016.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMapTable<KeyType, ObjectType> (LHUtils)

@property (nonatomic, copy, readonly) NSArray<KeyType> *allKeys;

@property (nonatomic, copy, readonly) NSArray<ObjectType> *allObjects;

- (nullable ObjectType)objectForKeyedSubscript:(nullable KeyType)key;

- (void)setObject:(nullable ObjectType)object forKeyedSubscript:(nullable KeyType)key;

- (BOOL)containsObject:(nullable ObjectType)object;

- (nullable KeyType)keyForObject:(nullable ObjectType)object;

@end

NS_ASSUME_NONNULL_END
