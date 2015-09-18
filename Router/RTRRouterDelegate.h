//
//  RTRRouterDelegate.h
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const RTRRouterNodeStateDidUpdateNotification;


@protocol RTRRouterDelegate <NSObject>

- (void)routerNodeStateDidUpdate:(RTRRouter *)router;

@end