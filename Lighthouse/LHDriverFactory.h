//
//  LHDriverFactory.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHDriver;
@protocol LHNode;
@class LHDriverTools;

NS_ASSUME_NONNULL_BEGIN


@protocol LHDriverFactory <NSObject>

- (nullable id<LHDriver>)driverForNode:(id<LHNode>)node withTools:(LHDriverTools *)tools;

@end


NS_ASSUME_NONNULL_END