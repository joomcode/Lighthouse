//
//  RTRCommandOrientedContent.h
//  Router
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContent.h"

@protocol RTRCommand;

typedef id (^RTRNodeContentDataInitBlock)(id<RTRCommand> command);
typedef void (^RTRNodeContentDataUpdateBlock)(id data, id<RTRCommand> command, BOOL animated);

@interface RTRCommandOrientedContent : NSObject <RTRNodeContent>

- (void)setDefaultDataInitBlock:(RTRNodeContentDataInitBlock)block;

- (void)bindCommandClass:(Class)commandClass toDataInitBlock:(RTRNodeContentDataInitBlock)block;

- (void)bindCommandClass:(Class)commandClass toDataUpdateBlock:(RTRNodeContentDataUpdateBlock)block;

@end
