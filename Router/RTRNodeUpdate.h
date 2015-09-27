//
//  RTRNodeUpdate.h
//  Router
//
//  Created by Nick Tymchenko on 24/09/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RTRNode;

typedef void (^RTRNodeUpdateBlock)(id<RTRNode> node);

@protocol RTRNodeUpdate <NSObject>

- (void)finish;

@end
