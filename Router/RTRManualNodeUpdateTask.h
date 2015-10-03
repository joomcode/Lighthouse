//
//  RTRManualNodeUpdateTask.h
//  Router
//
//  Created by Nick Tymchenko on 03/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRNodeUpdateTask.h"

@interface RTRManualNodeUpdateTask : RTRNodeUpdateTask

- (instancetype)initWithComponents:(RTRComponents *)components animated:(BOOL)animated nodeUpdateBlock:(void (^)())block;

@end
