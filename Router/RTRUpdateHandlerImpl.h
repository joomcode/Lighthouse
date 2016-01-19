//
//  RTRUpdateHandlerImpl.h
//  Router
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRUpdateHandler.h"

NS_ASSUME_NONNULL_BEGIN


@interface RTRUpdateHandlerImpl : NSObject <RTRUpdateHandler>

- (void)handleCommand:(id<RTRCommand>)command animated:(BOOL)animated;

- (void)handleStateUpdate:(RTRNodeState)state;

@end


NS_ASSUME_NONNULL_END