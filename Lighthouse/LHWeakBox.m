//
//  LHWeakBox.m
//  Lighthouse
//
//  Created by Artem Starosvetskiy on 04.12.2023.
//  Copyright © 2023 Pixty. All rights reserved.
//

#import "LHWeakBox.h"

NS_ASSUME_NONNULL_BEGIN

@implementation LHWeakBox {
    void *_memoryAddress;
}

- (instancetype)initWithObject:(nullable id)object {
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}

- (void)setObject:(nullable id)object {
    _object = object;
    _memoryAddress = (__bridge void *)object;
}

- (NSUInteger)hash {
    return (NSUInteger)_memoryAddress;
}

- (BOOL)isEqual:(nullable LHWeakBox *)other {
    if (![other isKindOfClass:[LHWeakBox class]]) {
        return NO;
    }

    return _object == other->_object;
}

@end

NS_ASSUME_NONNULL_END
