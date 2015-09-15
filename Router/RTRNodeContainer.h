//
//  RTRNodeContainer.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;

@protocol RTRNodeContainer <NSObject>

- (NSOrderedSet *)initializedNodes;

- (NSOrderedSet *)activeNodes;

- (void)activateNode:(id<RTRNode>)node;

@end
