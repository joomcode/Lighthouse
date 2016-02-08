//
//  LHDriver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHNodePresentationState.h"

@class LHDriverUpdateContext;

NS_ASSUME_NONNULL_BEGIN


@protocol LHDriver <NSObject>

@property (nonatomic, strong, readonly, nullable) id data;

- (void)updateWithContext:(LHDriverUpdateContext *)context;

- (void)presentationStateDidChange:(LHNodePresentationState)presentationState;

@end


NS_ASSUME_NONNULL_END