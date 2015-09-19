//
//  RTRCommandHandler.h
//  Router
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRCommand;

typedef void (^RTRCommandHandlerBlock)(id<RTRCommand> command, BOOL animated);

@protocol RTRCommandHandler <NSObject>

- (void)handleCommandClass:(Class)commandClass withBlock:(RTRCommandHandlerBlock)block;

- (void)handleCommand:(id<RTRCommand>)command withBlock:(RTRCommandHandlerBlock)block;

@end
