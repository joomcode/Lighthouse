//
//  LHUpdateHandlerDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHDriver.h"

@protocol LHCommand;
@protocol LHUpdateBus;

NS_ASSUME_NONNULL_BEGIN


typedef _Nullable id (^LHDriverDataInitBlock)(__kindof id<LHCommand> command, id<LHUpdateBus> updateBus);


@interface LHUpdateHandlerDriver : NSObject <LHDriver>

@property (nonatomic, copy, nullable) LHDriverDataInitBlock defaultDataInitBlock;

- (instancetype)initWithDefaultDataInitBlock:(nullable LHDriverDataInitBlock)block NS_DESIGNATED_INITIALIZER;

- (void)bindCommandClass:(Class)commandClass toDataInitBlock:(LHDriverDataInitBlock)block;

@end


NS_ASSUME_NONNULL_END