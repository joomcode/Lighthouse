//
//  LHNodeUpdateTask.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 26/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHTask.h"

@protocol LHNode;
@protocol LHCommand;
@class LHComponents;
@class LHTaskQueue;

NS_ASSUME_NONNULL_BEGIN


@interface LHNodeUpdateTask : NSObject <LHTask>

@property (nonatomic, strong, readonly) LHComponents *components;
@property (nonatomic, assign, readonly, getter = isAnimated) BOOL animated;

- (instancetype)initWithComponents:(LHComponents *)components animated:(BOOL)animated NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)cancel;

@end


@interface LHNodeUpdateTask (Subclassing)

- (nullable id<LHCommand>)command;

- (void)updateNodesWithCompletion:(LHTaskCompletionBlock)completion;

- (void)updateDriverForNode:(id<LHNode>)node withUpdateQueue:(LHTaskQueue *)updateQueue;

@end


NS_ASSUME_NONNULL_END