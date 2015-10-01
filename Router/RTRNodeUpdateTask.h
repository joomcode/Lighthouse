//
//  RTRNodeUpdateTask.h
//  Router
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRTask.h"

@protocol RTRNode;
@protocol RTRCommand;
@class RTRComponents;

@interface RTRNodeUpdateTask : NSObject <RTRTask>

@property (nonatomic, readonly) RTRComponents *components;
@property (nonatomic, readonly, getter = isAnimated) BOOL animated;

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated;

@end


@interface RTRNodeUpdateTask (Abstract)

- (id<RTRCommand>)command;

- (void)updateNodes;

- (BOOL)shouldUpdateContentForNode:(id<RTRNode>)node;

@end