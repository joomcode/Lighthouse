//
//  RTRCommandNodeUpdateTask.h
//  Router
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRNodeUpdateTask.h"

@protocol RTRCommand;
@protocol RTRCommandRegistry;

@interface RTRCommandNodeUpdateTask : RTRNodeUpdateTask

- (instancetype)initWithComponents:(RTRComponents *)components command:(id<RTRCommand>)command animated:(BOOL)animated;

@end
