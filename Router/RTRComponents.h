//
//  RTRComponents.h
//  Router
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RTRGraph;
@class RTRNodeDataStorage;
@protocol RTRDriverProvider;
@protocol RTRCommandRegistry;

NS_ASSUME_NONNULL_BEGIN


@interface RTRComponents : NSObject

@property (nonatomic, strong, readonly) RTRGraph *graph;

@property (nonatomic, strong, readonly) RTRNodeDataStorage *nodeDataStorage;

@property (nonatomic, strong, readonly) id<RTRDriverProvider> driverProvider;

@property (nonatomic, strong, readonly) id<RTRCommandRegistry> commandRegistry;

- (instancetype)initWithGraph:(RTRGraph *)graph
              nodeDataStorage:(RTRNodeDataStorage *)nodeDataStorage
               driverProvider:(id<RTRDriverProvider>)driverProvider
              commandRegistry:(id<RTRCommandRegistry>)commandRegistry NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END