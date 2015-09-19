//
//  RTRNode.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNodeChildrenState;

@protocol RTRNode <NSObject>

- (NSSet *)allChildren;

- (NSSet *)defaultActiveChildren;

- (id<RTRNodeChildrenState>)activateChildren:(NSSet *)children withCurrentState:(id<RTRNodeChildrenState>)currentState;

@end
