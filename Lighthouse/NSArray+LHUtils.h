//
//  NSArray+LHUtils.h
//  Lighthouse
//
//  Created by Makarov Yury on 19/01/2017.
//  Copyright (c) 2017 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (LHUtils)

- (nullable NSArray *)lh_commonSuffixWithArray:(NSArray *)array;

- (nullable NSArray *)lh_arraySuffixWithLength:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
