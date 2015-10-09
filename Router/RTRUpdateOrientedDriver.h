//
//  RTRUpdateOrientedDriver.h
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriver.h"

@protocol RTRCommand;
@protocol RTRUpdateHandler;

typedef id (^RTRDriverDataInitBlock)(id<RTRCommand> command, id<RTRUpdateHandler> updateHandler);

@interface RTRUpdateOrientedDriver : NSObject <RTRDriver>

@property (nonatomic, copy) RTRDriverDataInitBlock defaultDataInitBlock;

- (void)bindCommandClass:(Class)commandClass toDataInitBlock:(RTRDriverDataInitBlock)block;

@end
