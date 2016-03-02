//
//  LHTaskBlocks.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 02/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHTask.h"

NS_ASSUME_NONNULL_BEGIN


typedef void (^LHTaskBlock)();

typedef void (^LHAsyncTaskBlock)(LHTaskCompletionBlock completion);


NS_ASSUME_NONNULL_END
