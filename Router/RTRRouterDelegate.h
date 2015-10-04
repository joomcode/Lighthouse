//
//  RTRRouterDelegate.h
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const RTRRouterNodeStateDidUpdateNotification;
extern NSString * const RTRRouterNodeUserInfoKey;


@protocol RTRNode;

@protocol RTRRouterDelegate <NSObject>

- (void)router:(RTRRouter *)router nodeStateDidUpdate:(id<RTRNode>)node;

@end