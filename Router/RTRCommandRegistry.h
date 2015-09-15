//
//  RTRCommandRegistry.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;
@protocol RTRCommand;

@interface RTRCommandRegistry : NSObject

- (void)bindCommandClass:(Class)commandClass toNode:(id<RTRNode>)node;

@end


@interface RTRCommandRegistry (Query)

- (id<RTRNode>)nodeForCommand:(id<RTRCommand>)command;

@end