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

@protocol RTRCommandRegistry <NSObject>

- (id<RTRNode>)nodeForCommand:(id<RTRCommand>)command;

@end


@interface RTRCommandRegistry : NSObject <RTRCommandRegistry>

- (void)bindNode:(id<RTRNode>)node toCommandClass:(Class)commandClass;

@end