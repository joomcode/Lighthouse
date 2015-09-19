//
//  RTRCommandHandlerImpl.h
//  Router
//
//  Created by Nick Tymchenko on 19/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRCommandHandler.h"

@interface RTRCommandHandlerImpl : NSObject <RTRCommandHandler>

- (void)handleCommand:(id<RTRCommand>)command animated:(BOOL)animated;

@end
