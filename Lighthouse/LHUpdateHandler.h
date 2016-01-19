//
//  LHUpdateHandler.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodeState.h"

@protocol LHCommand;

NS_ASSUME_NONNULL_BEGIN


typedef void (^LHCommandHandlerBlock)(id<LHCommand> command, BOOL animated);
typedef void (^LHStateHandlerBlock)(LHNodeState state);


@protocol LHUpdateHandler <NSObject>

- (void)handleCommandClass:(Class)commandClass withBlock:(LHCommandHandlerBlock)block;

- (void)handleCommand:(id<LHCommand>)command withBlock:(LHCommandHandlerBlock)block;

- (void)handleStateUpdatesWithBlock:(LHStateHandlerBlock)block;

@end


NS_ASSUME_NONNULL_END