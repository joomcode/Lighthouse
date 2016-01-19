//
//  RTRTask.h
//  Router
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^RTRTaskCompletionBlock)();


@protocol RTRTask <NSObject>

- (void)startWithCompletionBlock:(RTRTaskCompletionBlock)completionBlock;

@end


NS_ASSUME_NONNULL_END