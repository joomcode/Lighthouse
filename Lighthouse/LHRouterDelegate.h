//
//  LHRouterDelegate.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LHRouter;
@protocol LHCommand;

NS_ASSUME_NONNULL_BEGIN


@protocol LHRouterDelegate <NSObject>

@optional

- (BOOL)router:(LHRouter *)router shouldAnimateDriverUpdatesForCommand:(id<LHCommand>)command;

@end


NS_ASSUME_NONNULL_END