//
//  LHUpdateBusImpl.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 20/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHUpdateBus.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHUpdateBusImpl : NSObject <LHUpdateBus>

- (void)handleCommand:(id<LHCommand>)command animated:(BOOL)animated;

- (void)handleStateUpdate:(LHNodePresentationState)state;

@end


NS_ASSUME_NONNULL_END