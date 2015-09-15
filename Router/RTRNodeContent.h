//
//  RTRNodeContent.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNodeContentUpdateContext;

@protocol RTRNodeContent <NSObject>

// TODO: replace data property with some methods creating data?

@property (nonatomic, readonly) id data;

- (void)performUpdateWithContext:(id<RTRNodeContentUpdateContext>)updateContext;

@end