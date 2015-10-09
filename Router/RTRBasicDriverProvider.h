//
//  RTRBasicDriverProvider.h
//  Router
//
//  Created by Nick Tymchenko on 15/09/15.
//  Copyright (c) 2015 Pixty. All rights reserved.
//

#import "RTRDriverProvider.h"

typedef id<RTRDriver> (^RTRDriverProvidingBlock)(id<RTRNode> node);

@interface RTRBasicDriverProvider : NSObject <RTRDriverProvider>

- (void)bindNode:(id<RTRNode>)node toBlock:(RTRDriverProvidingBlock)block;

- (void)bindNodes:(NSArray *)nodes toBlock:(RTRDriverProvidingBlock)block;

- (void)bindNodeClass:(Class)nodeClass toBlock:(RTRDriverProvidingBlock)block;

@end
