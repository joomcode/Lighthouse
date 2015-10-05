//
//  RTRCommandRegistry.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;
@protocol RTRCommand;
@class RTRTarget;

@protocol RTRCommandRegistry <NSObject>

- (RTRTarget *)targetForCommand:(id<RTRCommand>)command;

@end