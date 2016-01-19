//
//  LHRouterDelegate.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN


extern NSString * const LHRouterNodeStateDidUpdateNotification;
extern NSString * const LHRouterNodeUserInfoKey;


@protocol LHRouterDelegate <NSObject>

- (void)router:(LHRouter *)router nodeStateDidUpdate:(id<LHNode>)node;

@end


NS_ASSUME_NONNULL_END