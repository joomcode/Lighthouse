//
//  LHRouterDelegateImpl.m
//  Lighthouse
//
//  Created by Nick Tymchenko on 14/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "LHRouterDelegateImpl.h"
#import <UIKit/UIKit.h>

@implementation LHRouterDelegateImpl

#pragma mark - LHRouterDelegate

- (BOOL)router:(LHRouter *)router shouldAnimateDriverUpdatesForCommand:(id<LHCommand>)command {
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate router:router shouldAnimateDriverUpdatesForCommand:command];
    }
    
    return [UIApplication sharedApplication].applicationState == UIApplicationStateActive;
}

@end
