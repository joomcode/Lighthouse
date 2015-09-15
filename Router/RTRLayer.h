//
//  RTRLayer.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;

// TODO: figure out layers. Perhaps they should be nothing more but nodes?

@interface RTRLayer : NSObject

@property (nonatomic, readonly) id<RTRNode> rootNode;

- (instancetype)initWithRootNode:(id<RTRNode>)rootNode;

@end