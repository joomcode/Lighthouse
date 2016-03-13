//
//  LHRouterObserver.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 17/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol LHRouterObserver <NSObject>

@optional

- (void)routerStateDidChange:(LHRouter *)router;

@end


NS_ASSUME_NONNULL_END