//
//  RTRCompositeNodeContentProvider.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRCompositeNodeContentProvider.h"
#import "RTRCompositeNodeContent.h"

@interface RTRCompositeNodeContentProvider ()

@property (nonatomic, copy, readonly) NSDictionary *contentProvidersById;

@end


@implementation RTRCompositeNodeContentProvider

#pragma mark - Init

- (instancetype)init {
    return [self initWithContentProviders:nil];
}

- (instancetype)initWithContentProviders:(NSArray *)contentProviders {
    NSParameterAssert(contentProviders.count > 0);
    
    self = [super init];
    if (!self) return nil;
    
    NSMutableDictionary *contentProvidersById = [[NSMutableDictionary alloc] initWithCapacity:contentProviders.count];
    [contentProviders enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        contentProvidersById[[@(idx) stringValue]] = obj;
    }];
    
    _contentProvidersById = [contentProvidersById copy];
    
    return self;
}

#pragma mark - RTRNodeContentProvider

- (id<RTRNodeContent>)contentForNode:(id<RTRNode>)node {
    NSMutableDictionary *contentById = [[NSMutableDictionary alloc] initWithCapacity:self.contentProvidersById.count];
    
    [self.contentProvidersById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> providerId, id<RTRNodeContentProvider> provider, BOOL *stop) {
        id<RTRNodeContent> content = [provider contentForNode:node];
        if (content) {
            contentById[providerId] = content;
        }
    }];
    
    return [[RTRCompositeNodeContent alloc] initWithContentById:contentById];
}

@end
