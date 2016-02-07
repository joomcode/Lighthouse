//
//  LHContainerTransitionStyleRegistry.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 07/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHTransitionStyleRegistry.h"

@protocol LHContainerTransitionStyle;

@interface LHContainerTransitionStyleRegistry : LHTransitionStyleRegistry<id<LHContainerTransitionStyle>>

@end
