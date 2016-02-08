//
//  LHDriverProvider.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 08/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHDriver;
@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN


@protocol LHDriverProvider <NSObject>

- (nullable id<LHDriver>)driverForNode:(id<LHNode>)node;

@end


NS_ASSUME_NONNULL_END