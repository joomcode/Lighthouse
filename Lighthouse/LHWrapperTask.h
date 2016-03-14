//
//  LHWrapperTask.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHTask.h"
#import "LHTaskBlocks.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHWrapperTask : NSObject <LHTask>

- (instancetype)initWithTask:(id<LHTask>)task
              willStartBlock:(nullable LHTaskBlock)willStartBlock
              didFinishBlock:(nullable LHTaskBlock)didFinishBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
