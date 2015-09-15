//
//  RTRModalPresentationContent.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRModalPresentationContent.h"
#import "RTRNodeContentUpdateContext.h"
#import "RTRNodeChildrenState.h"

@interface RTRModalPresentationContent ()

@property (nonatomic, readonly) UIWindow *window;

@end


@implementation RTRModalPresentationContent

#pragma mark - Init

- (instancetype)init {
    return [self initWithWindow:nil];
}

- (instancetype)initWithWindow:(UIWindow *)window {
    NSParameterAssert(window != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _window = window;
    
    return self;
}

#pragma mark - RTRNodeContent

@synthesize data = _data;

- (void)setupDataWithCommand:(id<RTRCommand>)command {
}

- (void)performUpdateWithContext:(id<RTRNodeContentUpdateContext>)updateContext {
    // TODO: actual modal stuff
    
    NSAssert(updateContext.childrenState.activeChildren.count <= 1, nil); // TODO
    
    id<RTRNode> rootNode = updateContext.childrenState.activeChildren.firstObject;
    
    id<RTRNodeContent> rootNodeContent = [updateContext contentForNode:rootNode];
    NSAssert([rootNodeContent.data isKindOfClass:[UIViewController class]], @""); // TODO
    
    self.window.rootViewController = rootNodeContent.data;
}

@end
