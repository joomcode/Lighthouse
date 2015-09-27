//
//  RTRNodeContentFeedbackChannelImpl.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNodeContentFeedbackChannelImpl.h"

@interface RTRNodeContentFeedbackChannelImpl ()

@property (nonatomic, copy, readonly) id<RTRNodeUpdate> (^providerBlock)(RTRNodeUpdateBlock updateBlock);

@end


@implementation RTRNodeContentFeedbackChannelImpl

#pragma mark - Init

- (instancetype)init {
    return [self initWithNodeUpdateProviderBlock:nil];
}

- (instancetype)initWithNodeUpdateProviderBlock:(id<RTRNodeUpdate> (^)(RTRNodeUpdateBlock updateBlock))block {
    NSParameterAssert(block != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _providerBlock = [block copy];
    
    return self;
}

#pragma mark - RTRNodeContentFeedbackChannel

- (id<RTRNodeUpdate>)startNodeUpdateWithBlock:(RTRNodeUpdateBlock)updateBlock {
    NSParameterAssert(updateBlock != nil);
    return self.providerBlock(updateBlock);
}

@end
