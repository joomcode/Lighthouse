//
//  NSArray+LHUtils.m
//  Lighthouse
//
//  Created by Makarov Yury on 19/01/2017.
//  Copyright (c) 2017 Pixty. All rights reserved.
//

#import "NSArray+LHUtils.h"

@implementation NSArray (LHHelpers)

- (NSArray *)lh_commonSuffixWithArray:(NSArray *)array {
    if (self.count == 0 || array.count == 0) {
        return nil;
    }    
    NSMutableArray *result = [NSMutableArray array];
    NSInteger i = self.count - 1, j = array.count - 1;
    while (i >= 0 && j >=0 && [self[i] isEqual:array[j]]) {
        [result addObject:self[i]];
        --i; --j;
    }
    return [result copy];
}

- (NSArray *)lh_arraySuffixWithLength:(NSInteger)length {
    if (length == 0) {
        return nil;
    }
    return [self subarrayWithRange:NSMakeRange(self.count - length, length)];
}

@end
