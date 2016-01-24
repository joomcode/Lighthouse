//
//  LHDriverProviderContext.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 21/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LHDriverChannel;

NS_ASSUME_NONNULL_BEGIN


@protocol LHDriverProviderContext <NSObject>

@property (nonatomic, strong, readonly) id<LHDriverChannel> channel;

@end


NS_ASSUME_NONNULL_END