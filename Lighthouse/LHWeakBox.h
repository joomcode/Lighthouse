//
//  LHWeakBox.h
//  Lighthouse
//
//  Created by Artem Starosvetskiy on 04.12.2023.
//  Copyright © 2023 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHWeakBox<T> : NSObject

@property (nonatomic, weak, nullable) T object;

- (instancetype)initWithObject:(nullable T)object;

@end

NS_ASSUME_NONNULL_END
