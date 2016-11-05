//
//  LHComponents.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 29/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LHNodeTree;
@class LHNodeDataStorage;
@protocol LHDriverFactory;
@protocol LHCommandRegistry;
@protocol LHDriverProvider;
@protocol LHNode;

NS_ASSUME_NONNULL_BEGIN


@interface LHComponents : NSObject

@property (nonatomic, strong, readonly) LHNodeTree *tree;

@property (nonatomic, strong, readonly) LHNodeDataStorage *nodeDataStorage;

@property (nonatomic, strong, readonly) id<LHDriverFactory> driverFactory;

@property (nonatomic, strong, readonly) id<LHCommandRegistry> commandRegistry;

@property (nonatomic, strong, readonly) id<LHDriverProvider> driverProvider;

- (instancetype)initWithTree:(LHNodeTree *)tree
             nodeDataStorage:(LHNodeDataStorage *)nodeDataStorage
               driverFactory:(id<LHDriverFactory>)driverFactory
             commandRegistry:(id<LHCommandRegistry>)commandRegistry NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
