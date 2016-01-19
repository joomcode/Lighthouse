//
//  LHUpdateHandlerImpl.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "LHUpdateHandler.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHUpdateHandlerImpl : NSObject <LHUpdateHandler>

- (void)handleCommand:(id<LHCommand>)command animated:(BOOL)animated;

- (void)handleStateUpdate:(LHNodeState)state;

@end


NS_ASSUME_NONNULL_END