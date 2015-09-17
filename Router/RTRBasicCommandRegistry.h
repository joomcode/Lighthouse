//
//  RTRBasicCommandRegistry.h
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRCommandRegistry.h"

typedef id<RTRNode> (^RTRCommandNodeProvidingBlock)(id<RTRCommand> command);

@interface RTRBasicCommandRegistry : NSObject <RTRCommandRegistry>

- (void)bindCommandClass:(Class)commandClass toNode:(id<RTRNode>)node;

- (void)bindCommandClass:(Class)commandClass toBlock:(RTRCommandNodeProvidingBlock)block;

@end