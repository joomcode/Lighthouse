//
//  LHDriverProviderImpl.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 08/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHDriverProviderImpl.h"

@interface LHDriverProviderImpl ()

@property (nonatomic, copy, readonly) LHDriverProviderBlock block;

@end


@implementation LHDriverProviderImpl

#pragma mark - Init

- (instancetype)initWithBlock:(LHDriverProviderBlock)block {
    self = [super init];
    if (!self) return nil;
    
    _block = [block copy];
    
    return self;
}

#pragma mark - LHDriverProvider

- (id<LHDriver>)driverForNode:(id<LHNode>)node {
    return self.block(node).lastObject;
}

- (NSArray<id<LHDriver>> *)driversForNode:(id<LHNode>)node {
    return self.block(node);
}

@end
