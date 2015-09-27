//
//  RTRStackNodeChildrenState.h
//  Router
//
//  Created by Nick Tymchenko on 20/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRNodeChildrenState.h"

@class RTRNodeTree;

@interface RTRStackNodeChildrenState : NSObject <RTRNodeChildrenState>

- (instancetype)initWithStack:(NSOrderedSet *)stack;

@end
