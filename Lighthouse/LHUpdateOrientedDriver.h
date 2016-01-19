//
//  LHUpdateOrientedDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriver.h"

@protocol LHCommand;
@protocol LHUpdateHandler;

NS_ASSUME_NONNULL_BEGIN


typedef _Nullable id (^LHDriverDataInitBlock)(id<LHCommand> command, id<LHUpdateHandler> updateHandler);


@interface LHUpdateOrientedDriver : NSObject <LHDriver>

@property (nonatomic, copy, nullable) LHDriverDataInitBlock defaultDataInitBlock;

- (void)bindCommandClass:(Class)commandClass toDataInitBlock:(LHDriverDataInitBlock)block;

@end


NS_ASSUME_NONNULL_END