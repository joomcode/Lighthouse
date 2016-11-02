//
//  AppDelegate.h
//  LighthouseDemo
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LHRouter;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong, readonly) LHRouter *router;

@end

