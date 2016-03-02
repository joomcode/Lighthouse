//
//  LHManualNodeUpdateTask.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 03/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHManualNodeUpdateTask.h"

@interface LHManualNodeUpdateTask ()

@property (nonatomic, copy, readonly) LHAsyncTaskBlock block;

@end


@implementation LHManualNodeUpdateTask

#pragma mark - Init

- (instancetype)initWithComponents:(LHComponents *)components animated:(BOOL)animated block:(LHAsyncTaskBlock)block {
    self = [super initWithComponents:components animated:animated];
    if (!self) return nil;
    
    _block = [block copy];
    
    return self;
}

#pragma mark - LHNodeUpdateTask

- (void)updateNodesWithCompletion:(LHTaskCompletionBlock)completion {
    self.block(completion);
}

@end
