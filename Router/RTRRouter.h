//
//  RTRRouter.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;
@protocol RTRCommand;
@class RTRCommandRegistry;

@interface RTRRouter : NSObject

@property (nonatomic, strong) id<RTRNode> rootNode;

@property (nonatomic, strong) RTRCommandRegistry *commandRegistry;

@property (nonatomic, strong) NSArray *nodeContentProviders;

- (void)executeCommand:(id<RTRCommand>)command animated:(BOOL)animated;

@end
