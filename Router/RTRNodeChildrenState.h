//
//  RTRNodeChildrenState.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNodeChildrenState <NSObject>

@property (nonatomic, readonly) NSOrderedSet *initializedChildren;

@property (nonatomic, readonly) NSSet *activeChildren;

@end


@interface RTRNodeChildrenState : NSObject <RTRNodeChildrenState>

- (instancetype)initWithInitializedChildren:(NSOrderedSet *)initializedChildren
                     activeChildrenIndexSet:(NSIndexSet *)activeChildrenIndexSet;

@end