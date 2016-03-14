//
//  LHRouterDelegateImpl.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHRouterDelegate.h"

NS_ASSUME_NONNULL_BEGIN


@interface LHRouterDelegateImpl : NSObject <LHRouterDelegate>

@property (nonatomic, weak, nullable) id<LHRouterDelegate> delegate;

@end


NS_ASSUME_NONNULL_END