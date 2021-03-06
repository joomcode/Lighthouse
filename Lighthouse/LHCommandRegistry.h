//
//  LHCommandRegistry.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHNode;
@protocol LHCommand;
@class LHTarget;

NS_ASSUME_NONNULL_BEGIN


@protocol LHCommandRegistry <NSObject>

- (nullable LHTarget *)targetForCommand:(id<LHCommand>)command;

@end


NS_ASSUME_NONNULL_END