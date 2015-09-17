//
//  RTRNodeContentUpdateQueueImpl.m
//  Router
//
//  Created by Nick Tymchenko on 18/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentUpdateQueueImpl.h"

@interface RTRNodeContentUpdateQueueImpl ()

@property (nonatomic, strong) NSMutableArray *updateBlocks;

@property (nonatomic, assign) BOOL updateInProgress;

@end


@implementation RTRNodeContentUpdateQueueImpl

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _updateBlocks = [[NSMutableArray alloc] init];
    
    return self;
}

#pragma mark - RTRNodeContentUpdateQueue

- (void)enqueueBlock:(RTRNodeContentUpdateBlock)updateBlock {
    [self.updateBlocks addObject:updateBlock];
    
    [self dequeueUpdateIfPossible];
}

- (void)dequeueUpdateIfPossible {
    if (self.updateInProgress || self.updateBlocks.count == 0) {
        return;
    }
    
    self.updateInProgress = YES;
    
    RTRNodeContentUpdateBlock updateBlock = self.updateBlocks[0];
    [self.updateBlocks removeObjectAtIndex:0];
    
    updateBlock(^{
        self.updateInProgress = NO;
        [self dequeueUpdateIfPossible];
    });
}

@end
