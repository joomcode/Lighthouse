//
//  LHComponents.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LHGraph;
@class LHNodeDataStorage;
@protocol LHDriverProvider;
@protocol LHCommandRegistry;

NS_ASSUME_NONNULL_BEGIN


@interface LHComponents : NSObject

@property (nonatomic, strong, readonly) LHGraph *graph;

@property (nonatomic, strong, readonly) LHNodeDataStorage *nodeDataStorage;

@property (nonatomic, strong, readonly) id<LHDriverProvider> driverProvider;

@property (nonatomic, strong, readonly) id<LHCommandRegistry> commandRegistry;

- (instancetype)initWithGraph:(LHGraph *)graph
              nodeDataStorage:(LHNodeDataStorage *)nodeDataStorage
               driverProvider:(id<LHDriverProvider>)driverProvider
              commandRegistry:(id<LHCommandRegistry>)commandRegistry NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END