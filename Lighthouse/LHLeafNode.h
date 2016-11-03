//
//  LHLeafNode.h
//  Lighthouse
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "LHNode.h"

@interface LHLeafNode : NSObject <LHNode>

- (instancetype)initWithLabel:(nullable NSString *)label NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end
