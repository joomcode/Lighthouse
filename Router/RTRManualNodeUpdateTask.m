//
//  RTRManualNodeUpdateTask.m
//  Router
//
//  Created by Nick Tymchenko on 03/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRManualNodeUpdateTask.h"

@interface RTRManualNodeUpdateTask ()

@property (nonatomic, copy, readonly) void (^nodeUpdateBlock)();

@end


@implementation RTRManualNodeUpdateTask

#pragma mark - Init

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated {
    return [self initWithComponents:components animated:animated nodeUpdateBlock:nil];
}

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated nodeUpdateBlock:(void (^)())block {
    NSParameterAssert(block != nil);
    
    self = [super initWithComponents:components animated:animated];
    if (!self) return nil;
    
    _nodeUpdateBlock = [block copy];
    
    return self;
}

#pragma mark - RTRNodeUpdateTask

- (void)updateNodes {
    self.nodeUpdateBlock();
}

@end
