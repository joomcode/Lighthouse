//
//  LHManualNodeUpdateTask.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 03/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHNodeUpdateTask.h"
#import "LHTaskBlocks.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHManualNodeUpdateTask : LHNodeUpdateTask

- (instancetype)initWithComponents:(LHComponents *)components
                          animated:(BOOL)animated
                             block:(LHAsyncTaskBlock)block NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithComponents:(LHComponents *)components animated:(BOOL)animated NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
