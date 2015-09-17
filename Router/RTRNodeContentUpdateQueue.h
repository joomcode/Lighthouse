//
//  RTRNodeContentUpdateQueue.h
//  Router
//
//  Created by Nick Tymchenko on 18/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RTRNodeContentUpdateCompletionBlock)();
typedef void (^RTRNodeContentUpdateBlock)(RTRNodeContentUpdateCompletionBlock completion);

@protocol RTRNodeContentUpdateQueue <NSObject>

- (void)enqueueBlock:(RTRNodeContentUpdateBlock)updateBlock;

@end
