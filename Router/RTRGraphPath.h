//
//  RTRGraphPath.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTRLayer;

@interface RTRGraphPath : NSObject

@property (nonatomic, readonly) NSOrderedSet *layers;

- (NSOrderedSet *)nodesWithinLayer:(RTRLayer *)layer;

@end


// TODO: split into mutable subclass

@interface RTRGraphPath (Mutation)

- (void)addLayer:(RTRLayer *)layer withNodes:(NSOrderedSet *)nodes;

@end