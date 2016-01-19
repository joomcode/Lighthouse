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

NS_ASSUME_NONNULL_BEGIN


@interface RTRCommandNodeUpdateTask : RTRNodeUpdateTask

- (instancetype)initWithComponents:(RTRComponents *)components
                          animated:(BOOL)animated
                           command:(id<RTRCommand>)command NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END