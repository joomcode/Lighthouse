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

@property (nonatomic, copy, readonly) NSArray<KeyType> *lh_allKeys;

@property (nonatomic, copy, readonly) NSArray<ObjectType> *lh_allObjects;

- (BOOL)lh_containsObject:(nullable ObjectType)object;

- (nullable KeyType)lh_keyForObject:(nullable ObjectType)object;

@end

NS_ASSUME_NONNULL_END
