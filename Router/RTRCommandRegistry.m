//
//  RTRCommandRegistry.m
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRCommandRegistry.h"
#import "RTRCommand.h"

@interface RTRCommandRegistry ()

@property (nonatomic, strong) NSMutableDictionary *nodesByCommandClass;

@end


@implementation RTRCommandRegistry

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _nodesByCommandClass = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void)bindCommandClass:(Class)commandClass toNode:(id<RTRNode>)node {
    self.nodesByCommandClass[(id<NSCopying>)commandClass] = node;
}

- (id<RTRNode>)nodeForCommand:(id<RTRCommand>)command {
    return self.nodesByCommandClass[[command class]];
}

@end
