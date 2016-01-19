//
//  LHCommandNodeUpdateTask.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 27/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHNodeUpdateTask.h"

@protocol LHCommand;
@protocol LHCommandRegistry;

NS_ASSUME_NONNULL_BEGIN


@interface LHCommandNodeUpdateTask : LHNodeUpdateTask

- (instancetype)initWithComponents:(LHComponents *)components
                          animated:(BOOL)animated
                           command:(id<LHCommand>)command NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithComponents:(LHComponents *)components animated:(BOOL)animated NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END