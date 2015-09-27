//
//  RTRTask.h
//  Router
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RTRTaskCompletionBlock)();

@protocol RTRTask <NSObject>

- (void)startWithCompletionBlock:(RTRTaskCompletionBlock)completionBlock;

@end
