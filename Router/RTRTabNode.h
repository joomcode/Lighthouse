//
//  RTRTabNode.h
//  Router
//
//  Created by Nick Tymchenko on 14/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRNode.h"

@interface RTRTabNode : NSObject <RTRNode>

- (instancetype)initWithChildren:(NSOrderedSet *)children;

@end
