//
//  RTRRouterDelegate.h
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;

NS_ASSUME_NONNULL_BEGIN


extern NSString * const RTRRouterNodeStateDidUpdateNotification;
extern NSString * const RTRRouterNodeUserInfoKey;


@protocol RTRRouterDelegate <NSObject>

- (void)router:(RTRRouter *)router nodeStateDidUpdate:(id<RTRNode>)node;

@end


NS_ASSUME_NONNULL_END