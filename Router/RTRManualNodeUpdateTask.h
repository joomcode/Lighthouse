//
//  RTRManualNodeUpdateTask.h
//  Router
//
//  Created by Nick Tymchenko on 03/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRNodeUpdateTask.h"

NS_ASSUME_NONNULL_BEGIN


@interface RTRManualNodeUpdateTask : RTRNodeUpdateTask

- (instancetype)initWithComponents:(RTRComponents *)components
                          animated:(BOOL)animated
                   nodeUpdateBlock:(void (^)())block NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
