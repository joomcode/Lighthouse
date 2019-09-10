//
//  LHTransitionContext.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 08/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHTransitionContext.h"

@implementation LHTransitionContext

- (instancetype)initWithSource:(UIViewController *)source
                   destination:(UIViewController *)destination
                   styleSource:(UIViewController *)styleSource
              styleDestination:(UIViewController *)styleDestination
                       options:(NSDictionary<NSString *, id> *)options {
    self = [super init];
    if (!self) return nil;
    
    _source = source;
    _destination = destination;
    _styleSource = styleSource;
    _styleDestination = styleDestination;
    _options = [options copy];
    
    return self;
}

@end
