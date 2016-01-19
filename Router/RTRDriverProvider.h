//
//  RTRDriverProvider.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;
@protocol RTRDriver;

NS_ASSUME_NONNULL_BEGIN


@protocol RTRDriverProvider <NSObject>

- (nullable id<RTRDriver>)driverForNode:(id<RTRNode>)node;

@end


NS_ASSUME_NONNULL_END