//
//  RTRCommandOrientedContent.h
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContent.h"

@protocol RTRCommand;
@protocol RTRCommandHandler;

typedef id (^RTRNodeContentDataInitBlock)(id<RTRCommand> command, id<RTRCommandHandler> commandHandler);

@interface RTRCommandOrientedContent : NSObject <RTRNodeContent>

@property (nonatomic, copy) RTRNodeContentDataInitBlock defaultDataInitBlock;

- (void)bindCommandClass:(Class)commandClass toDataInitBlock:(RTRNodeContentDataInitBlock)block;

@end
