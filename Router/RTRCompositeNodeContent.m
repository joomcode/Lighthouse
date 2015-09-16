//
//  RTRCompositeNodeContent.m
//  Router
//
//  Created by Nick Tymchenko on 16/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRCompositeNodeContent.h"
#import "RTRNodeContentUpdateContextImpl.h"

@interface RTRCompositeNodeContent ()

@property (nonatomic, copy, readonly) NSDictionary *contentById;
@property (nonatomic, assign, readonly) BOOL hasFeedbackChannel;

@end

@implementation RTRCompositeNodeContent

#pragma mark - Init

- (instancetype)init {
    return [self initWithContentById:nil];
}

- (instancetype)initWithContentById:(NSDictionary *)contentById {
    NSParameterAssert(contentById != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _contentById = [contentById copy];
    
    for (id<RTRNodeContent> content in contentById.allValues) {
        if ([content respondsToSelector:@selector(setFeedbackChannel:)]) {
            _hasFeedbackChannel = YES;
            break;
        }
    }
    
    return self;
}

#pragma mark - RTRNodeContent

@dynamic data;
@synthesize feedbackChannel = _feedbackChannel;

- (id)data {
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:self.contentById.count];
    
    [self.contentById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> contentId, id<RTRNodeContent> content, BOOL *stop) {
        if (content.data) {
            data[contentId] = content.data;
        }
    }];
    
    return data;
}

- (void)setupDataWithCommand:(id<RTRCommand>)command {
    for (id<RTRNodeContent> content in self.contentById.allValues) {
        [content setupDataWithCommand:command];
    }
}

- (void)performUpdateWithContext:(id<RTRNodeContentUpdateContext>)updateContext {
    [self.contentById enumerateKeysAndObjectsUsingBlock:^(id<NSCopying> contentId, id<RTRNodeContent> content, BOOL *stop) {
        [content performUpdateWithContext:
            [[RTRNodeContentUpdateContextImpl alloc] initWithAnimated:updateContext.animated
                                                        childrenState:updateContext.childrenState
                                                         contentBlock:^id<RTRNodeContent>(id<RTRNode> node) {
                                                             return ((RTRCompositeNodeContent *)[updateContext contentForNode:node]).contentById[contentId];
                                                         }]];
    }];
}

- (void)setFeedbackChannel:(id<RTRNodeContentFeedbackChannel>)feedbackChannel {
    _feedbackChannel = feedbackChannel;
    
    for (id<RTRNodeContent> content in self.contentById.allValues) {
        if ([content respondsToSelector:@selector(setFeedbackChannel:)]) {
            content.feedbackChannel = feedbackChannel;
        }
    }
}

#pragma mark - NSObject trickery

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (!self.hasFeedbackChannel &&
        (aSelector == @selector(feedbackChannel) || aSelector == @selector(setFeedbackChannel:)))
    {
        return NO;
    }
    
    return [super respondsToSelector:aSelector];
}

@end
