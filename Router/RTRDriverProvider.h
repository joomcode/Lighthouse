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

@protocol RTRDriverProvider <NSObject>

- (id<RTRDriver>)driverForNode:(id<RTRNode>)node;

@end
