//
//  LHDriverTools.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 21/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHDriverProvider;
@protocol LHDriverChannel;

NS_ASSUME_NONNULL_BEGIN


@interface LHDriverTools : NSObject

@property (nonatomic, strong, readonly) id<LHDriverProvider> provider;

@property (nonatomic, strong, readonly) id<LHDriverChannel> channel;

- (instancetype)initWithProvider:(id<LHDriverProvider>)provider
                         channel:(id<LHDriverChannel>)channel NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END