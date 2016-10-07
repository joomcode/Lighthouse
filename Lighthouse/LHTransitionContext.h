//
//  LHTransitionContext.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 08/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface LHTransitionContext : NSObject

@property (nonatomic, weak, readonly) UIViewController *source;
@property (nonatomic, weak, readonly) UIViewController *destination;

@property (nonatomic, weak, readonly) UIViewController *styleSource;
@property (nonatomic, weak, readonly) UIViewController *styleDestination;

- (instancetype)initWithSource:(UIViewController *)source
                   destination:(UIViewController *)destination
                   styleSource:(UIViewController *)styleSource
              styleDestination:(UIViewController *)styleDestination NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END
