//
//  LHManualNodeUpdateTask.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 03/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHManualNodeUpdateTask.h"

@interface LHManualNodeUpdateTask ()

@property (nonatomic, copy, readonly) void (^nodeUpdateBlock)();

@end


@implementation LHManualNodeUpdateTask

#pragma mark - Init

- (instancetype)initWithComponents:(LHComponents *)components animated:(BOOL)animated nodeUpdateBlock:(void (^)())block {
    self = [super initWithComponents:components animated:animated];
    if (!self) return nil;
    
    _nodeUpdateBlock = [block copy];
    
    return self;
}

#pragma mark - LHNodeUpdateTask

- (void)updateNodes {
    self.nodeUpdateBlock();
}

@end
