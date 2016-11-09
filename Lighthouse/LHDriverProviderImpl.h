//
//  LHDriverProviderImpl.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 08/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHDriverProvider.h"

NS_ASSUME_NONNULL_BEGIN


typedef NSArray<id<LHDriver>> *(^LHDriverProviderBlock)(id<LHNode> _Nonnull node);


@interface LHDriverProviderImpl : NSObject <LHDriverProvider>

- (instancetype)initWithBlock:(LHDriverProviderBlock)block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
