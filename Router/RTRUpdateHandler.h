//
//  RTRUpdateHandler.h
//  Router
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTRNodeState.h"

@protocol RTRCommand;

typedef void (^RTRCommandHandlerBlock)(id<RTRCommand> command, BOOL animated);
typedef void (^RTRStateHandlerBlock)(RTRNodeState state);

@protocol RTRUpdateHandler <NSObject>

- (void)handleCommandClass:(Class)commandClass withBlock:(RTRCommandHandlerBlock)block;

- (void)handleCommand:(id<RTRCommand>)command withBlock:(RTRCommandHandlerBlock)block;

- (void)handleStateUpdatesWithBlock:(RTRStateHandlerBlock)block;

@end
