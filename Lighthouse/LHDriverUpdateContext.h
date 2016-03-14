//
//  LHDriverUpdateContext.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNode;
@protocol LHCommand;
@protocol LHNodeChildrenState;
@protocol LHTaskQueue;

NS_ASSUME_NONNULL_BEGIN


@interface LHDriverUpdateContext : NSObject

@property (nonatomic, assign, readonly, getter = isAnimated) BOOL animated;

@property (nonatomic, strong, readonly, nullable) id<LHCommand> command;

@property (nonatomic, strong, readonly, nullable) id<LHNodeChildrenState> childrenState;

@property (nonatomic, strong, readonly) id<LHTaskQueue> updateQueue;

- (instancetype)initWithAnimated:(BOOL)animated
                         command:(nullable id<LHCommand>)command
                   childrenState:(nullable id<LHNodeChildrenState>)childrenState
                     updateQueue:(id<LHTaskQueue>)updateQueue NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END