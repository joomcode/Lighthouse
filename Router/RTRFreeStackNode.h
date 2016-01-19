//
//  RTRFreeStackNode.h
//  Router
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRNode.h"

@class RTRNodeTree;

NS_ASSUME_NONNULL_BEGIN


@interface RTRFreeStackNode : NSObject <RTRNode>

- (instancetype)initWithTrees:(NSArray<RTRNodeTree *> *)trees NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END