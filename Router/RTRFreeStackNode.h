//
//  RTRFreeStackNode.h
//  Router
//
//  Created by Nick Tymchenko on 04/10/15.
//  Copyright © 2015 Pixty. All rights reserved.
//

#import "RTRNode.h"

@interface RTRFreeStackNode : NSObject <RTRNode>

- (instancetype)initWithTrees:(NSArray *)trees;

@end
